#' Convert the register data sources
#'
#' @param caption Caption to add to the table.
#'
#' @return A [tibble] object.
#' @keywords internal
#'
registers_as_md_table <- function(caption = NULL) {
  variable_description |>
    dplyr::select(
      .data$register_name,
      .data$register_abbrev,
      .data$start_year,
      .data$end_year
    ) |>
    dplyr::mutate(
      end_year = dplyr::if_else(is.na(.data$end_year), "present", as.character(.data$end_year)),
      years = glue::glue("{start_year} - {end_year}"),
      register_abbrev = glue::glue("`{register_abbrev}`")
    ) |>
    dplyr::distinct() |>
    dplyr::select(
      "Register" = .data$register_name,
      "Abbreviation" = .data$register_abbrev,
      "Years" = .data$years
    ) |>
    knitr::kable(caption = caption)
}
