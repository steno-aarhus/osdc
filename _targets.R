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
source(here::here("data-raw/simulate-data.R"))

# Replace the target list below with your own:
list(
  tar_target(
    name = algorithm_csv,
    command = "data-raw/algorithm.csv",
    format = "file"
  ),
  tar_target(
    name = algorithm,
    command = read_algorithm_data(algorithm_csv)
  ),
  tar_target(
    name = algorithm_rda,
    command = {
      usethis::use_data(algorithm, overwrite = TRUE)
      here::here("data/algorithm.rda")
    },
    format = "file"
  ),
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
    name = simulation_definitions_csv,
    command = "data-raw/simulation-definitions.csv",
    format = "file"
  ),
  tar_target(
    name = register_data,
    command = create_simulated_data(simulation_definitions_csv),
  ),
  tar_target(
    name = register_data_rda,
    command = {
      usethis::use_data(register_data, overwrite = TRUE)
      here::here("data/register_data.rda")
    },
    format = "file"
  ),
  tar_target(
    name = internal_rda,
    command = {
      usethis::use_data(algorithm,
        variable_description,
        register_data,
        overwrite = TRUE, internal = TRUE
      )
      here::here("R/sysdata.rda")
    },
    format = "file"
  )
)
