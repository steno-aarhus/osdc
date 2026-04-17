#' Join prepared registers
#'
#' @param register_list A list of the prepared registers, from e.g.
#'  [prepare_lpr2()].
#'
#' @returns A single object with all rows from each register in `register_list`.
#'
#' @export
#' @examples
#' register_data <- simulate_registers(c(
#'   "lpr_adm",
#'   "lpr_diag",
#'   "lpr3f_kontakter",
#'   "lpr3f_diagnoser",
#'   "sssy",
#'   "sysi"
#' ))
#' join_registers(list(
#'   prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
#'   prepare_lpr3f(
#'     register_data$lpr3f_kontakter,
#'     register_data$lpr3f_diagnoser
#'   )
#' ))
#' join_registers(list(register_data$sysi, register_data$sssy))
join_registers <- function(register_list) {
  checkmate::assert_list(register_list)
  register_list |>
    purrr::reduce(dplyr::union)
}

#' Join kept inclusion events.
#'
#' @description
#' This function joins the outputs from all the filtering
#' functions, by `pnr` and `dates`. Input datasets:
#'
#' - `diabetes_diagnoses`: Dates are the first and second hospital
#' diabetes diagnosis.
#'
#' - `podiatrist_services`: Dates are the first and second
#' diabetes-specific podiatrist record.
#'
#' - `gld_hba1c_after_drop_steps`: Dates are the first and second elevated HbA1c
#' test results (after excluding results potentially influenced by gestational diabetes), and the
#' first and second purchase of a glucose-lowering drug (after excluding
#' purchases potentially related to polycystic ovary syndrome or gestational diabetes).
#'
#' @param diabetes_diagnoses Output from the internal `keep_diabetes_diagnoses()`.
#' @param podiatrist_services Output from the internal `keep_podiatrist_services()`.
#' @param gld_hba1c_after_drop_steps Output from the internal `drop_pregnancies()` and
#'   `drop_pcos()`.
#'
#' @returns The same type as the input data, as a [duckplyr::duckdb_tibble()],
#'  with the joined columns from the output of the input. There will be 1-8
#'  rows per `pnr`.
#'
#' @noRd
#' @inherit algorithm seealso
join_inclusions <- function(
  diabetes_diagnoses,
  podiatrist_services,
  gld_hba1c_after_drop_steps
) {
  # This joins *only* by pnr and dates. If datasets have the same column
  # names, they will be renamed to differentiate them.
  # TODO: We may need to ensure that no two datasets have the same columns.
  diabetes_diagnoses |>
    dplyr::full_join(podiatrist_services, by = c("pnr", "date")) |>
    dplyr::full_join(gld_hba1c_after_drop_steps, by = c("pnr", "date")) |>
    # Propagate computed "has_" values to all rows per PNR
    # pnr's with only NA values are converted to FALSE (individuals with either no GLD purchases or no type-specific diabetes diagnoses).
    dplyr::mutate(
      dplyr::across(
        dplyr::starts_with("has_"),
        \(x) any(dplyr::coalesce(x, FALSE), na.rm = TRUE)
      ),
      .by = "pnr"
    )
}
