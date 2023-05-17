
#' A thin wrapper around the [haven::read_sas()] function.
#'
#' @param path Path to SAS file location.
#'
#' @return A data frame.
#' @export
#'
import_sas <- function(path) {
  haven::read_sas(data_file = path)
}

#' Save data as an RDS file.
#'
#' Compress can be set to TRUE to save space immediately (at the cost of speed
#' in filtering steps. Using compress steps after running filtering steps is
#' more optimal.
#'
#' @param data The data to save.
#' @param file The output file name for the RDS file.
#'
#' @return Outputs the file path, side effect of saving the data to RDS.
#' @export
#'
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

#' Import and save all SAS files into RDS format.
#'
#' To speed things up, install the `furrr` and use [future::plan()] with
#' [future::multisession()] before running the function to set up parallel
#' processing.
#'
#' @param sas_files A vector of SAS file paths.
#' @param output_dir The folder you want to save the data to.
#'
#' @return Save RDS file, invisibly return the data frame.
#' @export
#'
sas_to_rds_files <- function(sas_files, output_dir) {
  save_walk <- purrr::walk2
  import_map <- purrr::map2
  if (requireNamespace("furrr", quietly = TRUE)) {
    save_walk <- furrr::future_walk2
    import_map <- furrr::future_map2
  }

  imported_sas_data <- list(
    sas_files = sas_file_list,
    output_files = sas_file_list |>
      path_set_rds_ext() |>
      output_path(output_dir = output_dir)
  ) |>
    import_map(~ list(data = import_sas(path = .x), output_files = .y))

  imported_sas_data |>
    save_walk(~ save_rds(data = .x, file = .y))

  return(invisible(imported_sas_data$data))
}
