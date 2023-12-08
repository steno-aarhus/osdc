# Script to generate synthetic data for tests

# Load required libraries
library(stringr)
library(data.table)
library(tidyverse)
library(here)

# Load functions
source(here::here("R/functions.R"))

# MEDICATION DATA ---------------------------------------------------------

# Pseudo-lmdb:

#### Non-diabetes data:

# Set seed for reproducibility
set.seed(123)

# Create a dataframe with 1000 rows from 200 individuals
med_df <- data.frame(
  pnr = sprintf("%03d", 1:200),
  # ID variable
  eksd = as.Date(sample(
    seq(as.Date("1995-01-01"), as.Date("2014-12-31"), by = "day"), 1000, replace = TRUE
  )),
  # Date of purchase
  apk = sample(1:3, 1000, replace = TRUE),
  # Number of packages
  indo = ifelse(runif(1000) <= 0.05, "", sprintf(
    "%07d", sample(1:9999999, 50, replace = TRUE)
  )),
  # Indication for treatment
  ATC = paste(
    sample(LETTERS, 1000, replace = TRUE),
    sample(0:9, 1000, replace = TRUE),
    sample(0:9, 1000, replace = TRUE),
    sample(LETTERS, 1000, replace = TRUE),
    sample(LETTERS, 1000, replace = TRUE),
    sample(0:9, 1000, replace = TRUE),
    sample(0:9, 1000, replace = TRUE),
    sep = ""
  ),
  # ATC code
  volume = sample(20:100, 1000, replace = TRUE) # Volume
)

# Create a function to generate drug names based on ATC codes (replace this with your own drug name generation logic)
generateDrugName <- function(atc) {
  # You can implement your own logic to generate drug names based on ATC codes
  # Here, we are using a placeholder logic that simply returns the atc code.
  return(atc)
}

# Apply the function to create drug names
med_df$drugname <- sapply(med_df$ATC, generateDrugName)

#### Diabetes data:

# Create a dataframe with 1000 rows from 50 individuals
med_a10_df <- data.frame(
  pnr = sprintf("%03d", 1:50),
  # ID variable
  eksd = as.Date(sample(
    seq(as.Date("1995-01-01"), as.Date("2014-12-31"), by = "day"), 1000, replace = TRUE
  )),
  # Date of purchase
  apk = sample(1:3, 1000, replace = TRUE),
  # Number of packages
  indo = ifelse(runif(1000) <= 0.05, "", sprintf(
    "%07d", sample(1:9999999, 50, replace = TRUE)
  )),
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

med_a10_df[sample(nrow(med_a10_df), nrow(med_a10_df) / 2),]$ATC <-
  sample(c("A10BA02", "A10BJ02", "A10BJ06"),
         nrow(med_a10_df) / 2,
         replace = TRUE)

generateDrugName <- function(atc) {
  # You can implement your own logic to generate drug names based on ATC codes
  # Here, we are using a placeholder logic that simply returns the atc code.
  return(atc)
}

# Apply the function to create drug names
med_a10_df$drugname <- sapply(med_a10_df$ATC, generateDrugName)


replaceDrugNames <- function(data) {
  # Check if the data frame contains the necessary columns
  if (!all(c("ATC", "drugname") %in% colnames(data))) {
    cat("Required columns not found in the data frame.\n")
    return(NULL)
  }

  # Define replacement mappings for ATC codes
  replacement_mappings <- list("A10BJ02" = "Saxenda",
                               "A10BJ06" = "Wegovy Flextouch")

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
med_df[pnr %in% c(sprintf("%03d", 180:190)), `:=` (
  indo = sample(c("0000092", "0000276", "0000781"), 55, replace = TRUE),
  ATC = "A10BA02",
  drugname = "Metformin"
)]

# Handcode a few false-positive cases with purchases of Saxenda:
med_df[pnr %in% c(sprintf("%03d", 190:195)), `:=` (ATC = "A10BJ02",
                                                   drugname = "Saxenda")]

# Handcode a few false-positive cases with purchases of Wegovy:
med_df[pnr %in% c(sprintf("%03d", 195:200)), `:=` (ATC = "A10BJ06",
                                                   drugname = "Wegovy Flextouch")]



# Hospital diagnoses ------------------------------------------------------



# lpr_adm -----------------------------------------------------------------




# lpr_diag ----------------------------------------------------------------



# Health Service data -----------------------------------------------------

# create test health insurance df with 100 rows
health_insurance_df <- create_test_hi_df(num_samples = 100)

# Laboratory data ---------------------------------------------------------

# create test lab df with 100 rows
lab_df <- create_test_lab_df(num_samples = 100)
