#' Include only those with HbA1c above the required threshold.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT). Multiple elevated results on the
#' same day within each individual are deduplicated, to account for the same
#' test result often being reported twice (one for IFCC, one for DCCT units).
#'
#' The output is passed to the `exclude_pregnancy()` function for
#' filtering of elevated results due to potential gestational diabetes (see
#' below).
#'
#' @param lab_forsker The `lab_forsker` register.
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with three columns:
#'
#'   - `pnr`: Personal identification variable.
#'   - `dates`: The dates of all elevated HbA1c test results.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' simulate_registers("lab_forsker", 100)[[1]] |> include_hba1c()
#' }
include_hba1c <- function(lab_forsker) {
  logic <- logic_as_expr("is_hba1c_over_threshold")[[1]]

  lab_forsker |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic) |>
    # Keep only the columns we need.
    dplyr::mutate(
      pnr = .data$patient_cpr,
      date = .data$samplingdate,
      .keep = "none"
    ) |>
    # Remove any duplicates
    dplyr::distinct()
}
