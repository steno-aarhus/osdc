#' Create the LPR2 data needed for later purposes.
#'
#' Needs the LPR2 (`lpr_diag` and `lpr_adm`) registers.
#'
#' @param lpr_diag The diagnosis register.
#' @param lpr_adm The admission register.
#'
#' @return The same class as the input, defaults to a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_lpr2(
#'   lpr_adm = register_data$lpr_adm,
#'   lpr_diag = register_data$lpr_diag
#' )
#' }
create_lpr2 <- function(lpr_adm, lpr_diag) {
  verify_required_variables(lpr_adm, "lpr_adm")
  verify_required_variables(lpr_diag, "lpr_diag")
  lpr_diag <- lpr_diag |>
    column_names_to_lower() |>
    keep_needed_diagnosis_code() |>
    keep_needed_diagnosis_type()

  join_lpr2(
    lpr_diag = lpr_diag,
    lpr_adm = column_names_to_lower(lpr_adm)
  ) |>
    dplyr::mutate(
      is_primary = .data$c_diagtype == "A",
      # TODO: Include this in algorithm dataframe some how?
      is_t1d = stringr::str_detect(.data$c_diag, "^(249|DE10)"),
      is_t2d = stringr::str_detect(.data$c_diag, "^(250|DE11)"),
      department = get_department(.data$c_spec),
      date = yyyymmdd_to_iso(.data$d_inddto)
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "is_primary",
      "is_t1d",
      "is_t2d",
      "department"
    )
}

keep_needed_diagnosis_code <- function(data) {
  # TODO: Include this in algorithm dataframe some how?
  data |>
    dplyr::filter(stringr::str_detect(.data$c_diag, "^(DO|DZ3|DE1[0-4]|249|250)"))
}

keep_needed_diagnosis_type <- function(data) {
  # TODO: Include this in algorithm dataframe some how?
  data |>
    dplyr::filter(.data$c_diagtype %in% c("A", "B"))
}

join_lpr2 <- function(lpr_adm, lpr_diag) {
  dplyr::inner_join(
    lpr_adm,
    lpr_diag,
    by = "recnum"
  )
}

get_department <- function(x) {
  dplyr::case_when(
    # TODO: Include this in algorithm dataframe some how?
    x == "08" ~ "endocrinology",
    # < 8 and between 9-30
    stringr::str_detect(x, "(0[0-8]|9|[1-3][0-9])") ~ "other medical"
  )
}

yyyymmdd_to_iso <- function(x) {
  date = lubridate::as_date(x, format = "%Y%m%d")
}
