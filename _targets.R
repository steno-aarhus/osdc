# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c("tidyverse", "here"),
  # Set a seed for reproducibility (needed for data simulation)
  seed = 123
)

# Run the R scripts in the R/ folder with your custom functions:
source(here::here("data-raw/variable-description.R"))

# Replace the target list below with your own:
list(
  tar_target(
    name = variable_description_csv,
    command = "data-raw/variable-description.csv",
    format = "file"
  ),
  tar_target(
    name = variable_description,
    command = read_variable_description_data(variable_description_csv)
  ),
  tar_target(
    name = variable_description_rda,
    command = {
      usethis::use_data(variable_description, overwrite = TRUE)
      here::here("data/variable_description.rda")
    },
    format = "file"
  ),
  tar_target(
    name = internal_rda,
    command = {
      usethis::use_data(
        variable_description,
        overwrite = TRUE, internal = TRUE
      )
      here::here("R/sysdata.rda")
    },
    format = "file"
  )
)
