#' Include only those with HbA1c in the required range.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT).
#'
#' @param data The `lab_forsker` register.
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with two columns: `pnr` and `included_hba1c`.
#' @keywords internal
#'
#' @examples
#' register_data$lab_forsker |> include_hba1c()
include_hba1c <- function(data) {
  verify_required_variables(data, "lab_forsker")
  hba1c_criteria <- get_algorithm_logic("hba1c")
  data |>
    column_names_to_lower() |>
    dplyr::filter({{ hba1c_criteria }}) |>
    dplyr::transmute(
      pnr = .data$patient_cpr,
      included_hba1c = TRUE
    )
}

