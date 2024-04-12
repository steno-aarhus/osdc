# Script to generate synthetic data for tests

# Load required libraries
library(tidyverse)
library(here)
library(lubridate)
library(simstudy)

simulation_definitions_path <- fs::file_temp(ext = ".csv")
simulation_definitions <- here("data-raw/simulation-definitions.csv") |>
  read_csv() |>
  mutate(variance = NA,
         link = if_else(dist == "binary", "identity", NA)) |>
  filter(!is.na(formula)) |>
  select(varname = variable_name, formula, variance, dist, link)

simulation_definitions |>
  filter(!is.na(dist)) |>
  write_csv(simulation_definitions_path)

# Set seed for reproducibility
set.seed(123)

# Helper functions --------------------------------------------------------

pad_integers <- function(x, width) {
  x |>
    stringr::str_trunc(width = width, side = "left", ellipsis = "") |>
    stringr::str_pad(width = width, side = "left", pad = "0")
}

#' Create a vector of fake ATC Codes.
#'
#' @return A vector.
#'
#' @examples
#' create_fake_atc()
create_fake_atc <- function() {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(stringr::str_length(Koodi) == 7) |>
    dplyr::pull(Koodi) |>
    sample(1, replace = TRUE)
}

create_fake_date <- function(from = "1977-01-01", to = lubridate::today()) {
  seq(as_date(from), as_date(to), by = "day") |>
    sample(1)
}

create_long_integer <- function(length) {
  purrr::map(1:length, ~ sample(0:9, 1)) |>
    purrr::reduce( ~ paste(.x, .y, sep = "")) |>
    pad_integers(width = length)
}

create_fake_drugname <- function(atc, n) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::select(ATC = Koodi, drugname = en) |>
    dplyr::right_join(data, by = "ATC", relationship = "many-to-many")
}

to_wwyy <- function(x) {
  format(lubridate::as_date(x), format = "%W%y")
}

to_yyyymmdd <- function(x) {
  format(lubridate::as_date(x), format = "%Y%m%d")
}

fix_senere_afkraeftet <- function(x) {
  dplyr::if_else(
    x == 0,
    "Ja",
    "Nej"
  )
}

fix_analysiscode <- function(x) {
  stringr::str_c("NPU", x)
}

genData(100, defRead(simulation_definitions_path)) |>
  as_tibble()

simulation_definitions |>
  filter(dist == "uniformInt") |>
  pull(varname)

eval(parse(text = text))

# Medication data ---------------------------------------------------------

# Pseudo-lmdb:


## Diabetes data (ID 201-250):

# Create a dataframe with 1000 rows from 50 individuals
med_a10_df <- data.frame(
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
  )
)

# Hardcode half of purchases to be metformin, liraglutid or semaglutid:

med_a10_df[sample(nrow(med_a10_df), nrow(med_a10_df) / 2), ]$ATC <-
  sample(c("A10BA02", "A10BJ02", "A10BJ06"),
    nrow(med_a10_df) / 2,
    replace = TRUE
  )

replaceDrugNames <- function(data) {
  # With 50% replace rate
  # Define replacement mappings for ATC codes
  list(
    "A10BJ02" = "Saxenda",
    "A10BJ06" = "Wegovy Flextouch"
  )
}

false_positive <- function(proportion) {
  runif(1) < proportion
}

# Insert a few false-positive cases with purchases of metformin:
insert_false_metformin <- function(data, proportion = 0.05) {
  if (!all(colnames(data) %in% c("atc", "name"))) {
    return(data)
  }
  data |>
    dplyr::mutate(
      atc = dplyr::if_else(
        indo %in% c("0000092", "0000276", "0000781") & false_positive(proportion),
        "A10BA02",
        atc
      ),
      name = dplyr::if_else(
        indo %in% c("0000092", "0000276", "0000781") & false_positive(proportion),
        "metformin",
        name
      )
    )
}

insert_wegovy <- function() {

}

# Insert some false positives for Wegovy and Saxenda.
insert_drugnames <- function(x, atc, name, proportion = 0.05) {
  tibble::tribble(
    ~ATC, ~name,
    "A10BJ06", "Wegovy Flextouch",
    "A10BJ02", "Saxenda"
  )
  dplyr::if_else(
    ATC == atc & runif(1) < proportion,
    name,
    x
  )
}

fix_speciale <- function(x) {
  # TODO: Is this necessary?
  # 50% random samples between 100000 and 600000
  # 50% random samples from 540000 to 549999
  SPECIALE = ifelse(
    # repeat 0 and 1 num_samples times and randomise them
    sample(rep(c(0, 1), length.out = num_samples)),
    # sample 100000:600000 for all 1's
    sample(100000:600000, num_samples, replace = TRUE),
    # sample 540000:549999 for all 0's
    sample(540000:549999, num_samples, replace = TRUE)
  )
}

insert_analysiscode <- function(x) {
  # TODO: Is this necessary?
  # ANALYSISCODE: npu code of analysis type (chr)
  # 50% is either NPU27300 or NPU03835
  # other 50% is NPU10000 to NPU99999
  x
}
