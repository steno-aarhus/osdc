#' Classify diabetes status using Danish registers.
#'
#' This function requires that each source of raw data is represented as a single DuckDB object
#' in R (e.g. a connection to Parquet files). Each DuckDB object must contain a single table covering all years of that data source.
#'
#'
#' @param kontakter The contacts information register for lpr3
#' @param diagnoser The diagnoses information register for lpr3
#' @param lpr_diag The diagnoses information register for lpr2
#' @param lpr_adm The administrative information register for lpr2
#' @param sysi The SYSI register
#' @param sssy The SSSY register
#' @param lab_forsker The register for laboratory results for research
#' @param bef The BEF register
#' @param lmdb The LMDB register
#' @param stable_inclusion_start_date Cutoff date after which inclusion events
#'    are considered true incident diabetes cases. Defaults to "1998-01-01", as
#'    we presume the user is using data on pregnancy events from the the Patient Register
#'    and on purchases of glucose-lowering drugs from the Prescription Register
#'    from Jan 1 1997 onward (or earlier).
#'
#' @returns The same object type as the input data, which would be a
#'    [duckplyr::duckdb_tibble()] type object.
#' @export
#' @seealso See the [osdc] vignette for a detailed
#'   description of the internal implementation of this classification function.
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(
#'   c(
#'     "kontakter",
#'     "diagnoser",
#'     "lpr_diag",
#'     "lpr_adm",
#'     "sysi",
#'     "sssy",
#'     "lab_forsker",
#'     "bef",
#'     "lmdb"
#'   ),
#'   n = 10000
#' )
#' classify_diabetes(
#'   kontakter = register_data$kontakter,
#'   diagnoser = register_data$diagnoser,
#'   lpr_diag = register_data$lpr_diag,
#'   lpr_adm = register_data$lpr_adm,
#'   sysi = register_data$sysi,
#'   sssy = register_data$sssy,
#'   lab_forsker = register_data$lab_forsker,
#'   bef = register_data$bef,
#'   lmdb = register_data$lmdb
#' )
#' }
classify_diabetes <- function(
  kontakter,
  diagnoser,
  lpr_diag,
  lpr_adm,
  sysi,
  sssy,
  lab_forsker,
  bef,
  lmdb,
  stable_inclusion_start_date = "1998-01-01"
) {
  # Input checks -----
  check_is_duckdb(kontakter)
  check_is_duckdb(diagnoser)
  check_is_duckdb(lpr_diag)
  check_is_duckdb(lpr_adm)
  check_is_duckdb(sysi)
  check_is_duckdb(sssy)
  check_is_duckdb(lab_forsker)
  check_is_duckdb(bef)
  check_is_duckdb(lmdb)

  # Verification step -----
  kontakter <- select_required_variables(kontakter, "kontakter")
  diagnoser <- select_required_variables(diagnoser, "diagnoser")
  lpr_diag <- select_required_variables(lpr_diag, "lpr_diag")
  lpr_adm <- select_required_variables(lpr_adm, "lpr_adm")
  sysi <- select_required_variables(sysi, "sysi")
  sssy <- select_required_variables(sssy, "sssy")
  lab_forsker <- select_required_variables(lab_forsker, "lab_forsker")
  bef <- select_required_variables(bef, "bef")
  lmdb <- select_required_variables(lmdb, "lmdb")

  # Initially processing -----
  lpr2 <- prepare_lpr2(
    lpr_diag = lpr_diag,
    lpr_adm = lpr_adm
  )

  lpr3 <- prepare_lpr3(
    kontakter = kontakter,
    diagnoser = diagnoser
  )

  pregnancy_dates <- keep_pregnancy_dates(
    lpr2 = lpr2,
    lpr3 = lpr3
  )

  # Keep steps -----
  diabetes_diagnoses <- keep_diabetes_diagnoses(
    lpr2 = lpr2,
    lpr3 = lpr3
  ) |>
    add_t1d_diagnoses_cols() |>
    dplyr::select(
      -c(
        "is_primary_diagnosis",
        "is_diabetes_code",
        "is_t1d_code",
        "is_t2d_code",
        "is_endocrinology_dept",
        "is_medical_dept",
        "is_pregnancy_code"
      )
    )

  podiatrist_services <- keep_podiatrist_services(
    sysi = sysi,
    sssy = sssy
  )

  gld_purchases <- keep_gld_purchases(
    lmdb = lmdb
  )

  hba1c_over_threshold <- keep_hba1c(
    lab_forsker = lab_forsker
  )

  # Drop steps -----
  gld_hba1c_after_drop_steps <- gld_purchases |>
    drop_pcos(bef = bef) |>
    drop_pregnancies(
      pregnancy_dates = pregnancy_dates,
      included_hba1c = hba1c_over_threshold
    ) |>
    add_insulin_purchases_cols() |>
    dplyr::select(
      -c(
        "atc",
        "volume",
        "apk"
      )
    )

  # Join events, keeping only two earliest dates per "stream" -----
  inclusions <- join_inclusions(
    diabetes_diagnoses = keep_two_earliest_events(diabetes_diagnoses),
    podiatrist_services = keep_two_earliest_events(podiatrist_services),
    gld_hba1c_after_drop_steps = keep_two_earliest_events(
      gld_hba1c_after_drop_steps
    )
  )

  inclusions |>
    create_inclusion_dates(stable_inclusion_start_date) |>
    classify_t1d() |>
    # If has_t1d is NA, t2d will also be NA
    dplyr::mutate(has_t2d = !.data$has_t1d) |>
    # Drop those who don't have either type of diabetes
    dplyr::filter(!(is.na(.data$has_t1d) & is.na(.data$has_t2d))) |>
    dplyr::select(
      "pnr",
      "stable_inclusion_date",
      "raw_inclusion_date",
      "has_t1d",
      "has_t2d"
    )
}

check_is_duckdb <- function(data, call = rlang::caller_env()) {
  check <- checkmate::test_multi_class(
    data,
    classes = c(
      "tbl_duckdb_connection",
      "duckplyr_df",
      "duckplyr_tbl",
      "duckdb_connection"
    )
  )
  if (!check) {
    cli::cli_abort(
      message = c(
        "The data needs to be a DuckDB object because we heavily process the data.",
        "i" = "The data has the class{?es}: {.code {class(data)}}"
      ),
      call = call
    )
  }

  invisible(NULL)
}

#' After filtering, classify those with type 1 diabetes.
#'
#' @param data Joined data output from the filtering steps.
#'
#' @return The same object type as the input data, which would be a
#'    [duckplyr::duckdb_tibble()] type object.
#' @keywords internal
#'
classify_t1d <- function(data) {
  logic <- c(
    "has_t1d"
  ) |>
    logic_as_expression()

  data |>
    dplyr::mutate(
      has_t1d = !!logic$has_t1d
    )
}
