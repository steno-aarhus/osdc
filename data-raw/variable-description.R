create_variable_description_data <- function(path) {
  variable_description <- path |>
    readr::read_csv() |>
    dplyr::select(
      "register_name",
      "register_abbrev",
      "variable_name",
      "start_year",
      "end_year",
      "danish_description",
      "english_description"
    )

  # Save to `data/` to give users access to descriptions
  usethis::use_data(variable_description, overwrite = TRUE)

  # Save as internal as well to give our functions access it
  usethis::use_data(variable_description, overwrite = TRUE, internal = TRUE)
  fs::dir_ls(here::here("data"), regexp = "variable_description")
}
