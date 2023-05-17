# User specifies the directory of the folder with the raw SAS-files and which file names to be imported. Script then imports all the necessary files:

# Function for importing SAS to project:
import_sas <- function(path) {
  haven::read_sas(data_file = path)
}

save_rds <- function(data, file) {
  saveRDS(data, file, compress = TRUE)
  return(invisible(path))
}

path_set_rds_ext <- function(path) {
  fs::path_ext_set(path, ".rds")
}

output_path <- function(input_path, output_dir) {
  fs::path(output_dir, fs::path_file(input_path))
}

# Compress can be set to TRUE to save space immediately (at the cost of speed in filter.R. Using compress.R after running filter.R is more optimal.)

# Set in master.R:
# Regular expression to specify the files to import:
# Separate strings for splitting up importing operations across multiple machines, if available
# Set the root of the folders containing foreign file formats

# Execute the importation:

# To set parallel computing, use future::plan(future::multisession) *outside* of
# script/function
save_walk <- purrr::walk2
import_map <- purrr::map2
if (requireNamespace("furrr", quietly = TRUE)) {
  save_walk <- furrr::future_walk2
  import_map <- furrr::future_map2
}

# Import and save all SAS files
list(
  sas_files = sas_file_list,
  output_files = sas_file_list |>
    path_set_rds_ext() |>
    output_path(output_dir = here::here("data-raw"))
) |>
  import_map( ~ list(data = import_sas(path = .x), output_files = .y)) |>
  save_walk(~ save_rds(data = .x, file = .y))

