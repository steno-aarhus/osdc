# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  packages = c("tibble") # Packages that your targets need for their tasks.
  # format = "qs", # Optionally set the default storage format. qs is fast.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
source(here::here("data-raw/algorithm.R"))
source(here::here("data-raw/variable-description.R"))

# Replace the target list below with your own:
list(
  tar_target(
    name = algorithm_csv,
    command = "data-raw/algorithm.csv",
    format = "file"
  ),
  tar_target(
    name = algorithm_rda,
    command = create_algorithm_data(algorithm_csv),
    format = "file"
  ),
  tar_target(
    name = variable_description_csv,
    command = "data-raw/variable-description.csv",
    format = "file"
  ),
  tar_target(
    name = variable_description_rda,
    command = create_variable_description_data(variable_description_csv),
    format = "file"
  )
)
