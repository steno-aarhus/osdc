## code to prepare `variable-description` dataset goes here

library(tidyverse)

required_variables <- read_csv(here::here("data-raw/variable_description.csv")) |>
  select(register_abbrev = raw_register_filename, variable_name)

usethis::use_data(required_variables, overwrite = TRUE, internal = TRUE)
