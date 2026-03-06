#' Classify diabetes status using Danish registers.
#'
#' This function requires that each source of register data is represented
#' as a single DuckDB object in R (e.g. a connection to Parquet files).
#' Each DuckDB object must contain a single table covering all years of
#' that data source, or at least the years you have and are interested
#' in.
#'
#' @param kontakter The contacts information table from the LPR3 patient register
#' @param diagnoser The diagnoses information table from the LPR3 patient register
#' @param lpr_diag The diagnoses information table from the LPR2 patient register
#' @param lpr_adm The administrative information table from the LPR2 patient register
#' @param sysi The SYSI table from the health service register
#' @param sssy The SSSY table from the health service register
#' @param lab_forsker The register for laboratory results for research
#' @param bef The BEF table from the civil register
#' @param lmdb The LMDB table from the prescription register
#' @param stable_inclusion_start_date Cutoff date after which inclusion events
#' are considered true incident diabetes cases. Defaults to "1998-01-01",
#' which is one year after the data on pregnancy events from the Patient Register
#' are considered valid for dropping gestational diabetes-related purchases of
#' glucose-lowering drugs. This default assumes that the user is using LPR and
#' LMDB data from at least Jan 1 1997 onward. If the user only has access to LPR
#' and LMDB data from a later date, this parameter should be set to one year
#' after the beginning of the user's data coverage.
#'
#' @returns The same object type as the input data, which would be a
#'    [duckplyr::duckdb_tibble()] type object.
#' @export
#' @seealso See the [osdc] vignette for a detailed
#'   description of the internal implementation of this classification function.
#'
#' @examples
#' # Can't run this multiple times, will cause an error as the table
#' # has already been created in the DuckDB connection.
#' register_data <- registers() |>
#'   names() |>
#'   simulate_registers() |>
#'   purrr::map(duckplyr::as_duckdb_tibble) |>
#'   purrr::map(duckplyr::as_tbl)
#'
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

  # Convert to dbplyr connection with duckdb to use dbplyr functions
  # (since duckplyr is still in development).
  # Also need to convert here rather than as a function, because of the
  # way duckplyr works. It creates a temporary DuckDB DB in the background
  # based on the name of the object passed to it.
  registers <- list(
    kontakter = kontakter,
    diagnoser = diagnoser,
    lpr_diag = lpr_diag,
    lpr_adm = lpr_adm,
    sysi = sysi,
    sssy = sssy,
    lab_forsker = lab_forsker,
    bef = bef,
    lmdb = lmdb
  ) |>
    purrr::discard(is.null) |>
    purrr::map(verify_duckdb)

  # Verification step -----
  registers <- registers |>
    purrr::imap(\(table, name) select_required_variables(table, name))

  # Initially processing -----

  lpr2 <- prepare_lpr2(
    lpr_diag = registers$lpr_diag,
    lpr_adm = registers$lpr_adm
  )

  lpr3 <- prepare_lpr3(
    kontakter = registers$kontakter,
    diagnoser = registers$diagnoser
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
    sysi = registers$sysi,
    sssy = registers$sssy
  )

  gld_purchases <- keep_gld_purchases(
    lmdb = registers$lmdb
  )

  hba1c_over_threshold <- keep_hba1c(
    lab_forsker = registers$lab_forsker
  )

  # Drop steps -----
  gld_hba1c_after_drop_steps <- gld_purchases |>
    drop_pcos(bef = registers$bef) |>
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

verify_duckdb <- function(data, call = rlang::caller_env()) {
  check <- checkmate::test_multi_class(
    data,
    classes = c(
      "tbl_duckdb_connection",
      "duckdb_connection"
    )
  )
  if (!check) {
    cli::cli_abort(
      message = c(
        "The data needs to be a {.cls tbl_duckdb_connection} object because we heavily process the data and need the power.",
        "i" = "The data has the class{?es}: {.code {class(data)}}"
      ),
      call = call
    )
  }

  data
}

#' After filtering, classify those with type 1 diabetes.
#'
#' @param data Joined data output from the filtering steps.
#'
#' @return The same object type as the input data, which would be a
#'    [duckplyr::duckdb_tibble()] type object.
#' @keywords internal
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
