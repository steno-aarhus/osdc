## code to prepare `variable-description` dataset goes here

library(tidyverse)

variable_description <- here::here("data-raw/variable_description.csv") |>
  read_csv() |>
  select(
    register_name,
    register_abbrev,
    variable_name,
    start_year,
    end_year,
    danish_description,
    english_description
  )

# Save to `data/` to give users access to descriptions
usethis::use_data(variable_description, overwrite = TRUE)

# Save as internal as well to give our functions access it
usethis::use_data(variable_description, overwrite = TRUE, internal = TRUE)
