library(tidyverse)
library(rvest)

# Get ICD-8 codes -----------------------------------------------------------

#' Scrape SDS's website for their ICD-8 codes and saves to a file.
#'
#' @returns Saves a CSV file with ICD-8 codes. Outputs the path to the saved
#'   file.
#' @keywords internal
scrape_icd8_codes <- function() {
  output_path <- here::here("data-raw", "icd8-codes.csv")
  "https://sundhedsdatastyrelsen.dk/-/media/sds/filer/rammer-og-retningslinjer/klassifikationer/sks-download/lukkede-klassifikationer/icd-8-klassifikation.txt?la=da" |>
    readr::read_lines() |>
    stringr::str_trim() |>
    dplyr::as_tibble() |>
    tidyr::separate_wider_delim(
      .data$value,
      delim = stringr::regex("   +"),
      names = c("icd8", "description", "unknown"),
      too_many = "merge"
    ) |>
    dplyr::mutate(dplyr::across(tidyselect::everything(), stringr::str_trim)) |>
    dplyr::mutate(
      description = stringr::str_remove(.data$description, "\\d+"),
      icd8 = stringr::str_remove(.data$icd8, "dia")
    ) |>
    dplyr::select(.data$icd8) |>
    readr::write_csv(output_path)

  output_path
}

# Only run if needed to update.
# scrape_icd8_codes()
icd8 <- read_csv(here::here("data-raw/icd8-codes.csv"))$icd8

# ICD 10 ------------------------------------------------------------------

icd10 <- here::here("data-raw/icd10-codes.csv") |>
  read_delim(
    col_types = "cc",
    delim = ";"
  ) |>
  pull(.data$icd10)

# Simulation definitions --------------------------------------------------

simulation_definitions <- here::here("data-raw/simulation-definitions.csv") |>
  read_csv(show_col_types = FALSE) |>
  select("register_abbrev", "variable_name", "generator")

# Scrap hovedspeciale departments -----------------------------------------

hovedspeciale_departments <- "https://www.dst.dk/da/Statistik/dokumentation/Times/forebyggelsesregistret/spec" |>
  read_html() |>
  html_element(css = "table") |>
  html_table() |>
  pull(Tekst)

# Save internal data ------------------------------------------------------

usethis::use_data(
  icd8,
  icd10,
  simulation_definitions,
  hovedspeciale_departments,
  internal = TRUE,
  overwrite = TRUE
)
