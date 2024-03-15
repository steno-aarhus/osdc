## code to prepare `variable-description` dataset goes here

library(tidyverse)

variable_description <- here::here("data-raw/variable_description.csv") |>
  read_csv() |>
  select(
    register_name,
    register_abbrev = raw_register_filename,
    variable_name,
    years_covered,
    danish_description,
    english_description
  )

usethis::use_data(variable_description, overwrite = TRUE)
