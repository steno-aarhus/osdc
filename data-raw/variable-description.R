read_variable_description_data <- function(path) {
  path |>
    readr::read_csv(show_col_types = FALSE) |>
    dplyr::select(
      "register_name",
      "register_abbrev",
      "variable_name",
      "start_year",
      "end_year",
      "danish_description",
      "english_description"
    )
}
