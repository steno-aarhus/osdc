create_algorithm_data <- function(path) {
  algorithm <- readr::read_csv(path, show_col_types = FALSE)
  usethis::use_data(algorithm, overwrite = TRUE)
  fs::dir_ls(here::here("data"), regexp = "algorithm")
}
