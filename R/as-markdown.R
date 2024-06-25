#' Convert the register data sources
#'
#' @param caption Caption to add to the table.
#'
#' @return A character vector as a Markdown table.
#' @keywords internal
#'
registers_as_md_table <- function(caption = NULL) {
  rlang::check_installed("glue")
  rlang::check_installed("knitr")

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

#' Convert the register name into text to use in a Markdown header.
#'
#' @param register The abbreviation of the register name.
#'
#' @return A character vector.
#' @keywords internal
#'
register_as_md_header <- function(register) {
  rlang::check_installed("glue")

  variable_description |>
    dplyr::distinct(.data$register_name, .data$register_abbrev) |>
    dplyr::filter(.data$register_abbrev == register) |>
    glue::glue_data(
      "`{register_abbrev}`: {register_name}"
    )
}

#' Convert the fake register data into a Markdown table.
#'
#' @param data The data of a specific register from [register_data].
#' @param caption A caption to add to the table.
#'
#' @return A character vector as a Markdown table.
#' @keywords internal
#'
register_data_as_md_table <- function(data, caption = NULL) {
  rlang::check_installed("glue")
  rlang::check_installed("knitr")

  data |>
    utils::head(4) |>
    knitr::kable(caption = caption)
}

#' Converts the variables for a register into a Markdown table.
#'
#' @inheritParams register_data_as_md_table
#'
#' @return A character vector as a Markdown table.
#' @keywords internal
#'
variables_as_md_table <- function(register, caption = NULL) {
  rlang::check_installed("glue")
  rlang::check_installed("knitr")
  rlang::check_installed("stringr")

  variable_description |>
    dplyr::filter(.data$register_abbrev == register) |>
    dplyr::select(.data$variable_name, .data$english_description) |>
    dplyr::mutate(english_description = stringr::str_to_sentence(.data$english_description)) |>
    knitr::kable(caption = caption)
}
