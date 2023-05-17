# User specifies the directory of the folder with the raw SAS-files and which file names to be imported. Script then imports all the necessary files:

# Function for importing SAS to project:
import_sas <- function(filename, foreign_folder) {
  dt <- read_sas(paste(foreign_folder, "/", filename, sep = ""))
  saveRDS(dt, paste(here("data/raw"), regmatches(filename, regexpr("/.*$", filename)), ".rds", sep = ""), compress = TRUE)
}

# Compress can be set to TRUE to save space immediately (at the cost of speed in filter.R. Using compress.R after running filter.R is more optimal.)

# Set in master.R:
# Regular expression to specify the files to import:
# Separate strings for splitting up importing operations across multiple machines, if available
# Set the root of the folders containing foreign file formats

# Execute the importation:

# To set parallel computing, use future::plan(future::multisession) *outside* of
# script/function
import_walk <- purrr::walk
if (requireNamespace("furrr", quietly = TRUE)) {
  import_walk <- furrr::future_walk
}

# Import and save all SAS files
sas_file_list |>
  import_walk(import_sas, foreign_folder = foreign_folder)
