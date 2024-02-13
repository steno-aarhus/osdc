# Script to generate synthetic data for tests

# Load required libraries
library(tidyverse)
library(data.table)
library(here)
library(lubridate)

# Set seed for reproducibility
set.seed(123)

# Set number of rows to create for fake data
number_rows <- 1000


# Functions ---------------------------------------------------------------

#' Create a vector of fake PNR (person ID number).
#'
#' These numbers range from 001 to 100.
#'
#' @param n The number (length) of items to output.
#' @param number_subjects Number of patients to create
#'
#' @return A vector.
#'
#' @examples
#' create_fake_pnr(10)
create_fake_pnr <- function(n, number_subjects = 200) {
  1:number_subjects |>
    # Pad the string to match the number values, so that if 1000 `number_subjects`
    # is given, the string length of the output is 4 characters wide (e.g. "0001").
    stringr::str_pad(width = stringr::str_length(number_subjects), pad = "0") |>
    sample(number_rows, replace = TRUE)
}

#' Create a vector of fake ATC Codes.
#'
#' @inheritParams create_fake_pnr
#'
#' @return A vector.
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

create_fake_indication <- function(number_rows) {
  sample(1:9e8, number_rows, replace = TRUE) |>
    stringr::str_trunc(width = 7, ellipsis = "") |>
    stringr::str_pad(width = 7, pad = "0")
}

assign_drugname_from_atc <- function(data) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::select(ATC = Koodi, drugname = en) |>
    dplyr::right_join(data, by = "ATC", relationship = "many-to-many")
}

# Medication data ---------------------------------------------------------

# Pseudo-lmdb:

## Non-diabetes data:

# Create a tibble with 1000 rows from 200 individuals
med_df <- tibble(
  # ID variable
  pnr = create_fake_pnr(number_rows),
  # Date of purchase
  eksd = as_date(sample(
    seq(as_date("1995-01-01"), as_date("2014-12-31"), by = "day"), 1000,
    replace = TRUE
  )),
  # Number of packages
  apk = sample(1:3, 1000, replace = TRUE),
  # Indication for treatment
  indo = create_fake_indication(number_rows),
  # ATC code
  ATC = create_fake_atc(number_rows),
  # Volume
  volume = sample(20:100, 1000, replace = TRUE)
) |>
  assign_drugname_from_atc()

## Diabetes data:

# Create a dataframe with 1000 rows from 50 individuals
med_a10_df <- data.frame(
  pnr = create_fake_pnr(number_rows, number_subjects = 50),
  # ID variable
  eksd = as.Date(sample(
    seq(as.Date("1995-01-01"), as.Date("2014-12-31"), by = "day"), 1000,
    replace = TRUE
  )),
  # Date of purchase
  apk = sample(1:3, 1000, replace = TRUE),
  # Number of packages
  indo = create_fake_indication(number_rows),
  # Indication for treatment
  ATC = paste(
    rep(
      c(
        "A10AB",
        "A10AC",
        "A10AD",
        "A10AE",
        "A10BA",
        "A10BB",
        "A10BD",
        "A10BG",
        "A10BH",
        "A10BJ",
        "A10BK",
        "A10BX"
      ),
      80
    ),
    sample(0:9, 1000, replace = TRUE),
    sample(0:9, 1000, replace = TRUE),
    sep = ""
  ),
  # ATC code
  volume = sample(20:100, 1000, replace = TRUE) # Volume
)

# Hardcode half of purchases to be metformin, Liraglutide or semaglutide:

med_a10_df[sample(nrow(med_a10_df), nrow(med_a10_df) / 2), ]$ATC <-
  sample(c("A10BA02", "A10BJ02", "A10BJ06"),
    nrow(med_a10_df) / 2,
    replace = TRUE
  )

# Assign drugnames:
med_a10_df |>
  assign_drugname_from_atc()

replaceDrugNames <- function(data) {
  # Check if the data frame contains the necessary columns
  if (!all(c("ATC", "drugname") %in% colnames(data))) {
    cat("Required columns not found in the data frame.\n")
    return(NULL)
  }

  # Define replacement mappings for ATC codes
  replacement_mappings <- list(
    "A10BJ02" = "Saxenda",
    "A10BJ06" = "Wegovy Flextouch"
  )

  # Iterate through rows and make replacements
  for (i in 1:nrow(data)) {
    atc_code <- data$ATC[i]
    if (atc_code %in% names(replacement_mappings)) {
      # Check if the ATC code is in the mappings
      if (runif(1) < 0.5) {
        # Replace with the corresponding drug name with 50% probability
        data$drugname[i] <- replacement_mappings[[atc_code]]
      }
    }
  }

  return(data)
}

# Apply the function to create drug names
med_a10_df <- replaceDrugNames(med_a10_df)

med_df <- rbind(med_df, med_a10_df)

setDT(med_df)

# Handcode a few false-positive cases with purchases of metformin:
med_df[pnr %in% c(sprintf("%03d", 180:190)), `:=`(
  indo = sample(c("0000092", "0000276", "0000781"), 55, replace = TRUE),
  ATC = "A10BA02",
  drugname = "Metformin"
)]

# Handcode a few false-positive cases with purchases of Saxenda:
med_df[pnr %in% c(sprintf("%03d", 190:195)), `:=`(
  ATC = "A10BJ02",
  drugname = "Saxenda"
)]

# Handcode a few false-positive cases with purchases of Wegovy:
med_df[pnr %in% c(sprintf("%03d", 195:200)), `:=`(
  ATC = "A10BJ06",
  drugname = "Wegovy Flextouch"
)]

# Hospital diagnoses ------------------------------------------------------

# lpr_adm -----------------------------------------------------------------




# lpr_diag ----------------------------------------------------------------

# Health Service data -----------------------------------------------------

#' Create synthetic health insurance data
#'
#' @param num_samples Number of samples to create
#'
#' @return A [tibble::tibble()] with columns `pnr`, `BARNMAK`, `SPECIALE`, and `HONUGE`.
#'
#' @examples
#' create_test_hi_df(num_samples = 100)
create_test_hi_df <- function(num_samples) {
  tibble::tibble(
    pnr = create_fake_pnr(num_samples),

    # BARNMAK: service performed on patient' child or not (binary)
    # 1 = child, 0 = not, 5% are 1's
    BARNMAK = sample(c(0, 1), num_samples,
      replace = TRUE,
      prob = c(0.95, 0.05)
    ),

    # SPECIALE: service code (6-digit int)
    # 50% random samples between 100000 and 600000
    # 50% random samples from 540000 to 549999
    SPECIALE = ifelse(
      # repeat 0 and 1 num_samples times and randomise them
      sample(rep(c(0, 1), length.out = num_samples)),
      # sample 100000:600000 for all 1's
      sample(100000:600000, num_samples, replace = TRUE),
      # sample 540000:549999 for all 0's
      sample(540000:549999, num_samples, replace = TRUE)
    ),

    # HONUGE: year/week of the service being billed (4-digit chr)
    # first and second digits are random numbers between 01-52
    # third and fourth digits are random numbers between 00-99
    HONUGE = sprintf(
      "%02d%02d",
      sample(1:52, num_samples, replace = TRUE),
      sample(0:99, num_samples, replace = TRUE)
    )
  )
}

# create test health insurance df with 100 rows
health_insurance_df <- create_test_hi_df(num_samples = 100)

# Laboratory data ---------------------------------------------------------

#' Create synthetic lab data
#'
#' @param num_samples Number of samples to create
#'
#' @return A [tibble::tibble()] with columns `pnr`, `SAMPLINGDATE`, `ANALYSISCODE`, and `VALUE`.
#'
#' @examples
#' create_test_lab_df(num_samples = 100)
create_test_lab_df <- function(num_samples) {
  tibble::tibble(
    pnr = create_fake_pnr(num_samples),

    # SAMPLINGDATE: date of sample (date)
    # random dates between 1995-01-01 and 2015-12-31
    SAMPLINGDATE = sample(
      seq(lubridate::as_date("1995-01-01"), lubridate::as_date("2015-12-31"), by = "day"),
      num_samples,
      replace = TRUE
    ),

    # ANALYSISCODE: npu code of analysis type (chr)
    # 50% is either NPU27300 or NPU03835
    # other 50% is 'NPU'+random sample from 10000:99999
    ANALYSISCODE = sample(
      c(sample(c("NPU27300", "NPU03835"), num_samples / 2, replace = TRUE),
      paste0("NPU", sample(10000:99999, num_samples / 2, replace = TRUE)))
    ),

    # VALUE: numerical result of test (num)
    # random decimal number between 0.1-99.9
    VALUE = runif(num_samples, 0.1, 99.9)
  )
}

# create test lab df with 100 rows
test_lab_df <- create_test_lab_df(num_samples = 100)

usethis::use_data(test_lab_df, overwrite = TRUE, internal = TRUE)
