#' Classify diabetes status using Danish registers.
#'
#' @param kontakter The contacts register for lpr3
#' @param diagnoser The diagnoses register for lpr3
#' @param lpr_diag The diagnoses register for lpr2
#' @param lpr_adm The admissions register for lpr2
#' @param sysi The SYSI register
#' @param sssy The SSSY register
#' @param lab_forsker The lab forsker register
#' @param bef The BEF register
#' @param lmdb The LMDB register
#' @param stable_inclusion_start_date Cutoff date after which inclusion events
#'    are considered reliable (e.g., after changes in drug labeling or data
#'    entry practices). Defaults to "1998-01-01" which is one year after
#'    obstetric codes are reliable in the GLD data (since we use LPR data to
#'    drop rows related to gestational diabetes). This limits the included
#'    cohort to individuals with inclusion dates after this cutoff date.
#'
#' @returns The same object type as the input data, which would be a
#'   [tibble::tibble()] type object.
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

  # Inclusion steps -----
  diabetes_diagnoses <- include_diabetes_diagnoses(
    lpr2 = lpr2,
    lpr3 = lpr3
  ) |>
    add_t1d_diagnoses_cols()

  podiatrist_services <- include_podiatrist_services(
    sysi = sysi,
    sssy = sssy
  )

  gld_purchases <- include_gld_purchases(
    lmdb = lmdb
  )

  hba1c_over_threshold <- include_hba1c(
    lab_forsker = lab_forsker
  )

  # Exclusion steps -----
  gld_hba1c_after_exclusions <- gld_purchases |>
    exclude_potential_pcos(bef = bef) |>
    exclude_pregnancies(
      pregnancy_dates = pregnancy_dates,
      included_hba1c = hba1c_over_threshold
    ) |>
    add_insulin_purchases_cols() |>
    dplyr::select(
      -"atc",
      -"indication_code",
    )

  # Joining into an initial dataset -----
  inclusions <- join_inclusions(
    diabetes_diagnoses = diabetes_diagnoses,
    podiatrist_services = podiatrist_services,
    gld_hba1c_after_exclusions = gld_hba1c_after_exclusions
  )

  inclusions |>
    create_inclusion_dates(stable_inclusion_start_date = ) |>
    classify_t1d() |>
    # If has_t1d is NA, t2d will also be NA
    dplyr::mutate(has_t2d = !.data$has_t1d) |>
    dplyr::select(
      "pnr",
      # "stable_inclusion_date",
      # "raw_inclusion_date",
      "has_t1d",
      "has_t2d"
    )
}

#' After inclusion and exclusion, classify those with type 1 diabetes.
#'
#' @param data Joined data output from the inclusion and exclusion steps.
#'
#' @return The same object type as the input data, which would be a
#'   [tibble::tibble()] type object.
#' @keywords internal
#'
classify_t1d <- function(data) {
  logic <- c(
    "has_t1d"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)

  data |>
    dplyr::mutate(
      has_t1d = !!logic$has_t1d
    )
}
