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
  lmdb
) {
  # Verification step -----
  verify_required_variables(kontakter, "kontakter")
  verify_required_variables(diagnoser, "diagnoser")
  verify_required_variables(lpr_diag, "lpr_diag")
  verify_required_variables(lpr_adm, "lpr_adm")
  verify_required_variables(sysi, "sysi")
  verify_required_variables(sssy, "sssy")
  verify_required_variables(lab_forsker, "lab_forsker")
  verify_required_variables(bef, "bef")
  verify_required_variables(lmdb, "lmdb")

  # Initially processing -----
  lpr2 <- prepare_lpr2(
    lpr_diag = lpr_diag,
    lpr_adm = lpr_adm
  )

  lpr3 <- prepare_lpr3(
    kontakter = kontakter,
    diagnoser = diagnoser
  )

  # pregnancy_dates <-  get_pregrancy_dates(
  #   lpr2 = lpr2,
  #   lpr3 = lpr3
  # )

  Inclusion steps -----
  diabetes_diagnoses <-  include_diabetes_diagnoses(
    lpr2 = lpr2,
    lpr3 = lpr3
  )

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
    exclude_potential_pcos(bef = bef)
  #   |>
  #   exclude_pregnancy(
  #     # TODO: Need to think about arg naming here..
  #     included_hba1c = hba1c_over_threshold,
  #     pregnancy_dates = pregnancy_dates
  #   )

  # Joining into an initial dataset -----
  # inclusions <- join_inclusions(
  #   included_diabetes_diagnoses,
  #   included_podiatrist_services,
  #   exclusions
  # )

  # inclusions |>
  #   create_inclusion_dates() |>
  #   classify_t1d()
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
  # data |>
  #   get_has_t1d_primary_diagnosis() |>
  #   get_only_insulin_purchases() |>
  #   get_majority_of_t1d_primary_diagnosis() |>
  #   get_insulin_purchases_within_180_days() |>
  #   get_insulin_is_two_thirds_of_gld_purchases()
}
