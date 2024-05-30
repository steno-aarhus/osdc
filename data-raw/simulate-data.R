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

pad_integers <- function(x, width) {
  x |>
    stringr::str_trunc(width = width, side = "left", ellipsis = "") |>
    stringr::str_pad(width = width, side = "left", pad = "0")
}

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

create_fake_icd8 <- function(n) {
  here("data-raw/icd8-codes.csv") |>
    read_csv() |>
    pull(icd8) |>
    sample(size = n, replace = TRUE)
}

create_fake_icd10 <- function(n) {
  # from: https://medinfo.dk/sks/brows.php?s_nod=6308
  here("data-raw/icd10-codes.csv") |>
    read_csv2(show_col_types = FALSE) |>
    pull(icd10) |>
    sample(size = n, replace = TRUE)
}

create_fake_atc <- function(n) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(stringr::str_length(Koodi) == 7) |>
    dplyr::pull(Koodi) |>
    sample(n, replace = TRUE)
}

create_fake_date <- function(n, from = "1977-01-01", to = lubridate::today()) {
  seq(as_date(from), as_date(to), by = "day") |>
    sample(n, replace = TRUE)
}

create_padded_integer <- function(n, length) {
  purrr::map(1:length, \(ignore) sample(0:9, n, replace = TRUE)) |>
    purrr::reduce(\(integer1, integer2) paste(integer1, integer2, sep = "")) |>
    pad_integers(width = length)
}

create_fake_npu <- function(n) {
  stringr::str_c(
    "NPU",
    create_padded_integer(n, 5)
  )
}

create_fake_hovedspeciale_ans <- function(n) {
  "https://www.dst.dk/da/Statistik/dokumentation/Times/forebyggelsesregistret/spec" |>
    read_html() |>
    html_element("table") |>
    html_table() |>
    pull(Tekst) |>
    sample(n, replace = TRUE)
}

create_fake_drug_name <- function(atc) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(Koodi %in% atc) |>
    dplyr::pull(en) |>
    sample(length(atc), replace = TRUE)
}

to_wwyy <- function(x) {
  paste0(lubridate::isoweek(lubridate::as_date(x)), stringr::str_sub(lubridate::isoyear(lubridate::as_date(x)), -2))
}

to_yyyymmdd <- function(x) {
  format(lubridate::as_date(x), format = "%Y%m%d")
}

# Insert extra values to overrepresent certain values ------------------------------------------------------

insertion_rate <- function(proportion) {
  runif(1) < proportion
}

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

# Insert a few cases where purchases of metformin are used for other purposes
# than diabetes.
insert_false_metformin <- function(data, proportion = 0.05) {
  if (!all(colnames(data) %in% c("atc", "name"))) {
    return(data)
  }
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
}

# Insert some false positives for Wegovy and Saxenda.
insert_false_drug_names <- function(data, proportion = 0.05) {
  if (!all(colnames(data) %in% c("atc", "name"))) {
    return(data)
  }
  data |>
    mutate(
      name = case_when(
        atc == "A10BJ06" & insertion_rate(proportion) ~ "Wegovy Flextouch",
        atc == "A10BJ02" & insertion_rate(proportion) ~ "Saxenda",
        TRUE ~ name
      )
    )
}

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

# TODO: Need a function to reuse recnum and dw_ek_kontakt in LPR data

# Simulate data -----------------------------------------------------------

# use the simulation definition data to simulate some data
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

add_fake_drug_name <- function(data) {
  data |>
    mutate(
      across(
        matches("^name$"),
        \(x) create_fake_drug_name(atc = atc)
      )
    )
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
