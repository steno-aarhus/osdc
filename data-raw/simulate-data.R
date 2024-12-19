# Script to generate simulated data for tests and examples

# Load required libraries
library(tidyverse)
library(here)
library(lubridate)
library(fabricatr)
library(rvest)

# Get ICD-8 codes -----------------------------------------------------------

# "https://sundhedsdatastyrelsen.dk/-/media/sds/filer/rammer-og-retningslinjer/klassifikationer/sks-download/lukkede-klassifikationer/icd-8-klassifikation.txt?la=da" |>
#   read_lines() |>
#   str_trim() |>
#   as_tibble() |>
#   separate_wider_delim(
#     value,
#     delim = regex("   +"),
#     names = c("icd8", "description", "unknown"),
#     too_many = "merge"
#   ) |>
#   mutate(across(everything(), str_trim)) |>
#   mutate(
#     description = str_remove(description, "\\d+"),
#     icd8 = str_remove(icd8, "dia")
#   ) |>
#   select(icd8) |>
#   write_csv(here("data-raw/icd8-codes.csv"))

# Simulation functions -----------------------------------------------------

#'  Zero pad an integer to a specific length
#'
#' @param x An integer or vector of integers.
#' @param width An integer describing the final width of the zero-padded integer.
#' @keywords internal
#'
#' @return A character vector of integers.
#'
#' @examples
#' pad_integers(x = 1, width = 5)
#' pad_integers(x = c(1, 2, 3), width = 10)
pad_integers <- function(x, width) {
  x |>
    stringr::str_trunc(width = width, side = "left", ellipsis = "") |>
    stringr::str_pad(width = width, side = "left", pad = "0")
}

#' Create a vector with random ICD-8 or -10 diagnoses
#'
#' @param n The number of ICD-8 or -10 diagnoses to generate.
#' @param date A date determining whether the diagnoses should be ICD-8 or ICD-10. If null, a random date will be sampled to determine which ICD revision the diagnosis should be from. In the Danish registers, ICD-10 is used after 1994.
#'
#' @return A character vector of ICD-10 diagnoses.
#'
#' @examples
#' create_fake_icd(10)
#' create_fake_icd(5, "1995-04-19")
create_fake_icd <- function(n, date = NULL) {
  if (is.null(date)) {
    date <- sample(c("1993-01-01", "1995-01-01"), 1)
  }

  if (date >= "1994-01-01") {
    create_fake_icd10(n)
  } else {
    create_fake_icd8(n)
  }
}

#' Create a vector of random ICD-8 diagnoses

#' @description
#' ICD-8 is the 8th revision of the International Classification of Diseases.
#'
#' @param n The number of ICD-8 diagnoses to generate.
#'
#' @return A character vector of ICD-8 diagnoses.
#'
#' @examples
#' create_fake_icd8(1)
create_fake_icd8 <- function(n) {
  here("data-raw/icd8-codes.csv") |>
    read_csv() |>
    pull(icd8) |>
    sample(size = n, replace = TRUE)
}

#' Create a vector of random ICD-10 diagnoses.
#'
#' @description
#' ICD-10 is the 10th revision of the International Classification of Diseases.
#'
#' @param n An integer determining how many diagnoses to create.
#'
#' @return A character vector of ICD-10 diagnoses.
#'
#' @examples
#' create_fake_icd10(3)
create_fake_icd10 <- function(n) {
  # from: https://medinfo.dk/sks/brows.php?s_nod=6308
  here("data-raw/icd10-codes.csv") |>
    read_csv2(show_col_types = FALSE) |>
    pull(icd10) |>
    sample(size = n, replace = TRUE)
}

#' Create a vector with random ATC codes
#'
#' @description
#' Anatomical Therapeutic Chemical (ATC) codes are unique medicine codes
#' based on on what organ or system it works on and how it works.
#'
#' @param n The number of random ATC codes to generate.
#'
#' @return A character vector of ATC codes.
#'
#' @examples
#' create_fake_atc(10)
create_fake_atc <- function(n) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(stringr::str_length(Koodi) == 7) |>
    dplyr::pull(Koodi) |>
    sample(n, replace = TRUE)
}

#' Create fake dates
#'
#' @param n The number of dates to generate.
#' @param from A date determining the first date in the interval to sample from.
#' @param to A date determining the last date in the interval to sample from.
#'
#' @return A vector of dates.
#'
#' @examples
#' create_fake_date(20)
#' create_fake_date(20, "1995-04-19", "2024-04-19")
create_fake_date <- function(n, from = "1977-01-01", to = lubridate::today()) {
  seq(as_date(from), as_date(to), by = "day") |>
    sample(n, replace = TRUE)
}

#' Create a vector of random zero-padded integers.
#'
#' @param n The number of integers to generate.
#' @param length An integer determining the length of the padded integer.
#'
#' @return A character vector of integers.
#'
#' @examples
#' create_padded_integer(5, 10)
create_padded_integer <- function(n, length) {
  purrr::map(1:length, \(ignore) sample(0:9, n, replace = TRUE)) |>
    purrr::reduce(\(integer1, integer2) paste(integer1, integer2, sep = "")) |>
    pad_integers(width = length)
}

#' Create a vector of random NPU codes
#'
#' @description
#' Nomenclature for Properties and Units (NPUs) are codes that identifies
#' laboratory results.
#'
#' @param n The number of NPUs to create.
#'
#' @return A character vector.
#'
#' @examples
#' create_fake_npu(4)
create_fake_npu <- function(n) {
  stringr::str_c(
    "NPU",
    create_padded_integer(n, 5)
  )
}

#' Create a vector of random department specialties
#'
#' @param n The number of department specialties to create.
#'
#' @return A character vector.
#'
#' @examples
#' create_fake_hovedspeciale_ans(1000)
create_fake_hovedspeciale_ans <- function(n) {
  "https://www.dst.dk/da/Statistik/dokumentation/Times/forebyggelsesregistret/spec" |>
    read_html() |>
    html_element("table") |>
    html_table() |>
    pull(Tekst) |>
    sample(n, replace = TRUE)
}

#' Create a vector of drug names based on a vector of ATC codes
#'
#' @param atc A character describing an ATC code.
#'
#' @return A character vector with the drug name of the given ATC code.
#'
#' @examples
#' create_fake_drug_name("A03FA05")
#' create_fake_drug_name(c("A03FA05", "A02BA04"))
create_fake_drug_name <- function(atc) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(Koodi %in% atc) |>
    dplyr::pull(en) |>
    sample(length(atc), replace = TRUE)
}

#' Transform date(s) to the format yyww
#'
#' @param x A date or a vector of dates.
#'
#' @return A vector of dates in the format yyww.
#'
#' @examples
#' to_yyww("2020-12-01")
#' to_yyww(c("2020-01-12", "1995-04-19"))
to_yyww <- function(x) {
  paste0(stringr::str_sub(lubridate::isoyear(lubridate::as_date(x)), -2), lubridate::isoweek(lubridate::as_date(x)))
}

#' Transform date(s) to the format yyyymmdd
#'
#' @param x A date or a vector of dates.
#'
#' @return A vector of dates in the format yyyymmdd.
#'
#' @examples
#' to_yyyymmdd("2020-12-01")
#' to_yyyymmdd(c("2020-01-12", "1995-04-19"))
to_yyyymmdd <- function(x) {
  format(lubridate::as_date(x), format = "%Y%m%d")
}

# Insert extra values to overrepresent certain values ------------------------------------------------------

#' Generate logic based on a probability
#'
#' @param proportion A double between 0 and 1.
#'
#' @return A logic vector. TRUE if the random number is less than the proportion,
#' otherwise FALSE.
#'
#' @examples
#' insertion_rate(0.3)
insertion_rate <- function(proportion) {
  runif(1) < proportion
}

#' Insert specific ATC codes based on a proportion
#'
#' @param data A tibble.
#' @param proportion Proportion to be resampled. Defaults to 0.3.
#'
#' @return A tibble with a proportion of resampled ATC codes for columns
#' named 'atc'
#'
#' @examples
insert_specific_atc <- function(data, proportion = 0.3) {
  glucose_lowering_drugs <- c(
    metformin = "A10AB02",
    # "A10AC",
    # "A10AD",
    insulin_liraglutid = "A10AE56",
    # "A10BA",
    # "A10BB",
    # "A10BD",
    # "A10BG",
    # "A10BH",
    liraglutid = "A10BJ02",
    semaglutid = "A10BJ06",
    dapagliflozin = "A10BK01",
    empagliflozin = "A10BK03"
    # "A10BX"
  )
  data |>
    mutate(
      across(
        matches("^atc$"),
        \(column) if_else(
          runif(n()) < proportion,
          sample(unname(glucose_lowering_drugs), 1),
          column
        )
      )
    )
}

#' Insert cases where metformin is used for other purposes than diabetes
#'
#' @description
#' This function uses the variable 'indo' which is the code for the underlying
#' condition treated by the prescribed medication.
#'
#' @param data A tibble.
#' @param proportion Proportion to resample. Defaults to 0.05.
#'
#' @return A tibble. If all column names in the tibble is either 'atc' or
#' 'name', a proportion of observations is resampled as metmorfin.
insert_false_metformin <- function(data, proportion = 0.05) {
  if (all(c("atc", "name", "indo") %in% colnames(data))) {
    data |>
      dplyr::mutate(
        atc = dplyr::if_else(
          indo %in% c("0000092", "0000276", "0000781") & insertion_rate(proportion),
          "A10BA02",
          atc
        ),
        name = dplyr::if_else(
          indo %in% c("0000092", "0000276", "0000781") & insertion_rate(proportion),
          "metformin",
          name
        )
      )
  } else {
  data
  }
}

# Insert false positives for Wegovy and Saxenda
#'
#' @param data A tibble.
#' @param proportion Proportion to resample. Defaults to 0.05.
#'
#' @return A tibble. If all column names in the tibble is either 'atc' or 'name'
#' and the atc is a A10BJ06 or A10BJ02, a proportion of observations is resampled
#' to have the name Wegovy Flextouch or Saxenda.
insert_false_drug_names <- function(data, proportion = 0.05) {
  if (all(c("atc", "name") %in% colnames(data))) {
    data |>
      mutate(
        name = case_when(
          atc == "A10BJ06" & insertion_rate(proportion) ~ "Wegovy Flextouch",
          atc == "A10BJ02" & insertion_rate(proportion) ~ "Saxenda",
          TRUE ~ name
        )
      )
  } else {
    data
  }
}

#' Insert additional analysis codes for HbA1c
#'
#' @param data A tibble.
#' @param proportion Proportion to resample. Defaults to 0.3.
#'
#' @return A tibble. If a column is named "analysiscode", a proportion of the
#' values are replaced by codes for HbA1c.
insert_analysiscode <- function(data, proportion = 0.3) {
  # NPU27300: New units for HbA1c
  # NPU03835: Old units for HbA1c
  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::matches("^analysiscode$"),
        \(column) dplyr::if_else(
          runif(dplyr::n()) < proportion,
          sample(c("NPU27300", "NPU03835"), dplyr::n(), replace = TRUE),
          column
        )
      )
    )
}

#' Add drug names (from ATC codes)
#'
#' @param data A tibble.
#'
#' @return A tibble. For columns named "name", a fake drug name (atc) will be
#' added.
add_fake_drug_name <- function(data) {
  data |>
    mutate(
      across(
        matches("^name$"),
        \(x) create_fake_drug_name(atc = atc)
      )
    )
}

# TODO: Need a function to reuse recnum and dw_ek_kontakt in LPR data

# Simulate data -----------------------------------------------------------

#' Simulate data based on simulation definitions
#'
#' @param data A tibble with simulation definitions.
#' @param n Number of observations to simulate.
#'
#' @return A tibble with simulated data.
simulate_data <- function(data, n) {
  # N needs to be capitalized for fabricatr, and but to be consistent
  # with other functions and their use of `n`, I kept it lowercase for
  # the function argument.
  N <- n
  data$generator |>
    as.list() |>
    set_names(data$variable_name) |>
    # this evaluates the character string
    map(~ eval(parse(text = .x))) |>
    # enframe converts a list to a tibble
    imap(\(column, name) enframe(column, name = NULL, value = name)) |>
    unname() |>
    list_cbind()
}

set.seed(123)
simulation_definitions <- here("data-raw/simulation-definitions.csv") |>
  read_csv(show_col_types = FALSE) |>
  select(register_abbrev, variable_name, generator)

simulation_definitions_list <- simulation_definitions |>
  group_split(register_abbrev)

register_data <- simulation_definitions_list |>
  map(\(data) simulate_data(data, n = 1000)) |>
  map(insert_specific_atc) |>
  map(add_fake_drug_name) |>
  map(insert_false_drug_names) |>
  map(insert_false_metformin) |>
  map(insert_analysiscode) |>
  # add the register abbreviations as a name to the list
  set_names(
    map_chr(
      simulation_definitions_list,
      \(data) unique(data$register_abbrev)
    )
  )

usethis::use_data(register_data, overwrite = TRUE)
