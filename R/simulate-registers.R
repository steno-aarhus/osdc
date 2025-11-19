# Get ICD-8 codes -----------------------------------------------------------

#' Scrape SDS's website for their ICD-8 codes and saves to a file.
#'
#' @returns Saves a CSV file with ICD-8 codes. Outputs the path to the saved
#'   file.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' scrape_icd8_codes()
#' }
scrape_icd8_codes <- function() {
  output_path <- fs::path_package("osdc", "resources", "icd8-codes.csv")
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

# Simulation functions -----------------------------------------------------

#' Zero pad an integer to a specific length
#'
#' @param x An integer or vector of integers.
#' @param width An integer describing the final width of the zero-padded integer.
#'
#' @return A character vector of integers.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' pad_integers(x = 1, width = 5)
#' pad_integers(x = c(1, 2, 3), width = 10)
#' }
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
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_icd(10)
#' create_fake_icd(5, "1995-04-19")
#' }
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
#'
#' ICD-8 is the 8th revision of the International Classification of Diseases.
#'
#' @param n The number of ICD-8 diagnoses to generate.
#'
#' @return A character vector of ICD-8 diagnoses.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_icd8(1)
#' }
create_fake_icd8 <- function(n) {
  fs::path_package("osdc", "resources", "icd8-codes.csv") |>
    readr::read_csv(show_col_types = FALSE) |>
    dplyr::pull(.data$icd8) |>
    sample(size = n, replace = TRUE)
}

#' Create a vector of random ICD-10 diagnoses
#'
#' ICD-10 is the 10th revision of the International Classification of Diseases.
#'
#' @param n An integer determining how many diagnoses to create.
#'
#' @return A character vector of ICD-10 diagnoses.
#' @keywords internal
#'
#' @source The stored CSV is downloaded from the Danish Health Data Authority's
#'   website at [medinfo.dk](https://medinfo.dk/sks/brows.php).
#'
#' @examples
#' \dontrun{
#' create_fake_icd10(3)
#' }
create_fake_icd10 <- function(n) {
  # Downloaded from: https://medinfo.dk/sks/brows.php
  fs::path_package("osdc", "resources", "icd10-codes.csv") |>
    readr::read_delim(
      col_types = "cc",
      delim = ";"
    ) |>
    dplyr::pull(.data$icd10) |>
    sample(size = n, replace = TRUE)
}

#' Create a vector with random ATC codes
#'
#' Anatomical Therapeutic Chemical (ATC) codes are unique medicine codes
#' based on on what organ or system it works on and how it works.
#'
#' @param n The number of random ATC codes to generate.
#'
#' @return A character vector of ATC codes.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_atc(10)
#' }
create_fake_atc <- function(n) {
  codeCollection::ATCKoodit |>
    tibble::as_tibble() |>
    dplyr::filter(stringr::str_length(.data$Koodi) == 7) |>
    dplyr::pull(.data$Koodi) |>
    sample(n, replace = TRUE)
}

#' Create fake dates
#'
#' @param n The number of dates to generate.
#' @param from A date determining the first date in the interval to sample from.
#' @param to A date determining the last date in the interval to sample from.
#'
#' @return A vector of dates.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_date(20)
#' create_fake_date(20, "1995-04-19", "2024-04-19")
#' }
create_fake_date <- function(n, from = "1977-01-01", to = lubridate::today()) {
  seq(lubridate::as_date(from), lubridate::as_date(to), by = "day") |>
    sample(n, replace = TRUE)
}

#' Create a vector of reproducible, random zero-padded integers.
#'
#' For a given number of generated integers that are the same length, they will
#' always be identical. This makes it easier to do joining by
#' values that represent people, e.g. in `pnr`, `cpr`, `recnum` and
#' `dw_ek_kontakt`.
#'
#' @param n The number of integer strings to generate.
#' @param length The length of the padded integer strings.
#'
#' @return A character vector of integers.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_padded_integer(n = 10, length = 13)
#' }
create_padded_integer <- function(n, length) {
  # Creates different sequences of strings for keys of different length.
  # E.g. pnr and recnum aren't duplicates of one another, apart from
  # their differing zero-padding/lengths.
  set.seed(length)

  purrr::map(1:length, \(ignore) sample(0:9, n, replace = TRUE)) |>
    purrr::reduce(\(integer1, integer2) paste(integer1, integer2, sep = "")) |>
    pad_integers(width = length)
}

#' Create a vector of random NPU codes
#'
#' Nomenclature for Properties and Units (NPUs) are codes that identifies
#' laboratory results.
#'
#' @param n The number of NPUs to create.
#'
#' @return A character vector.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_npu(4)
#' }
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
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' create_fake_hovedspeciale_ans(1000)
#' }
create_fake_hovedspeciale_ans <- function(n) {
  # TODO: It isn't great practice
  "https://www.dst.dk/da/Statistik/dokumentation/Times/forebyggelsesregistret/spec" |>
    rvest::read_html() |>
    rvest::html_element(css = "table") |>
    rvest::html_table() |>
    dplyr::pull(.data$Tekst) |>
    sample(n, replace = TRUE)
}

# Transformations/fixes ----------------------------------------------------

#' Transform date(s) to the format `yyww`
#'
#' @param x A date or a vector of dates.
#'
#' @return A vector of dates in the format `yyww`.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' to_yyww("2020-12-01")
#' to_yyww("2001-01-01")
#' to_yyww(c("2020-01-12", "1995-04-19"))
#' }
to_yyww <- function(x) {
  paste0(
    stringr::str_sub(lubridate::isoyear(lubridate::as_date(x)), -2),
    pad_integers(lubridate::isoweek(lubridate::as_date(x)), 2)
  )
}

#' Transform date(s) to the format `yyyymmdd`
#'
#' @param x A date or a vector of dates.
#'
#' @return A vector of dates in the format `yyyymmdd.`
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' to_yyyymmdd("2020-12-01")
#' to_yyyymmdd(c("2020-01-12", "1995-04-19"))
#' }
to_yyyymmdd <- function(x) {
  format(lubridate::as_date(x), format = "%Y%m%d")
}

#' Convert all factor variables to character variables.
#'
#' @param data A tibble or data frame.
#'
#' @returns A  [duckplyr::duckdb_tibble()].
#' @keywords internal
#'
fct_to_chr <- function(data) {
  data |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::where(is.factor),
        as.character
      )
    )
}

# Insert extra values to over-represent certain values ------------------------------------------------------

#' Generate logic based on a probability
#'
#' @param proportion A double between 0 and 1.
#'
#' @return A logic vector. TRUE if the random number is less than the
#'   proportion, otherwise FALSE.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' insertion_rate(0.3)
#' }
insertion_rate <- function(proportion) {
  stats::runif(1) < proportion
}

#' Insert specific ATC codes based on a proportion
#'
#' @param data A tibble.
#' @param proportion Proportion to be resampled. Defaults to 0.3.
#'
#' @return A tibble with a proportion of resampled ATC codes for columns named
#'   'atc'
#' @keywords internal
insert_specific_atc <- function(data, proportion = 0.3) {
  glucose_lowering_drugs <- c(
    metformin = "A10AB02",
    insulin_liraglutid = "A10AE56",
    liraglutid = "A10BJ02",
    semaglutid = "A10BJ06",
    dapagliflozin = "A10BK01",
    empagliflozin = "A10BK03"
  )
  data |>
    dplyr::mutate(
      dplyr::across(
        tidyselect::matches("^atc$"),
        \(column) {
          dplyr::if_else(
            stats::runif(dplyr::n()) < proportion,
            sample(unname(glucose_lowering_drugs), 1),
            column
          )
        }
      )
    )
}

#' Insert cases where metformin is used for other purposes than diabetes
#'
#' This function uses the variable `indo` which is the code for the underlying
#' condition treated by the prescribed medication.
#'
#' @param data A tibble.
#' @param proportion Proportion to re-sample. Defaults to 0.05.
#'
#' @return A tibble. If all column names in the tibble is either `atc`, a
#'   proportion of observations is re-sampled as metformin.
#' @keywords internal
insert_false_metformin <- function(data, proportion = 0.05) {
  if (all(c("atc", "indo") %in% colnames(data))) {
    data |>
      dplyr::mutate(
        atc = dplyr::if_else(
          .data$indo %in%
            c("0000092", "0000276", "0000781") &
            insertion_rate(proportion),
          "A10BA02",
          .data$atc
        )
      )
  } else {
    data
  }
}

#' Insert additional analysis codes for HbA1c
#'
#' @param data A tibble.
#' @param proportion Proportion to re-sample. Defaults to 0.3.
#'
#' @return A tibble. If a column is named `analysiscode`, a proportion of the
#'   values are replaced by codes for HbA1c.
#' @keywords internal
insert_analysiscode <- function(data, proportion = 0.3) {
  # NPU27300: New units for HbA1c
  # NPU03835: Old units for HbA1c
  data |>
    dplyr::mutate(
      dplyr::across(
        dplyr::matches("^analysiscode$"),
        \(column) {
          dplyr::if_else(
            stats::runif(dplyr::n()) < proportion,
            sample(c("NPU27300", "NPU03835"), dplyr::n(), replace = TRUE),
            column
          )
        }
      )
    )
}

# Simulate data -----------------------------------------------------------

#' Simulate data based on simulation definitions
#'
#' @param data A tibble with simulation definitions.
#' @param n Number of observations to simulate.
#'
#' @return A tibble with simulated data.
#' @keywords internal
create_simulated_data <- function(data, n) {
  # N needs to be capitalized for fabricatr, and but to be consistent
  # with other functions and their use of `n`, I kept it lowercase for
  # the function argument.
  N <- n
  data$generator |>
    as.list() |>
    rlang::set_names(data$variable_name) |>
    # this evaluates the character string
    purrr::map(~ eval(parse(text = .x))) |>
    # enframe converts a list to a tibble
    purrr::imap(
      \(column, name) tibble::enframe(column, name = NULL, value = name)
    ) |>
    unname() |>
    purrr::list_cbind()
}

#' Simulate a fake data frame of one or more Danish registers
#'
#' @param registers The name of the register you want to simulate.
#' @param n The number of rows to simulate for the resulting register.
#'
#' @returns A list with simulated register data (as DuckDB objects).
#' @export
#'
#' @examples
#' simulate_registers(c("bef", "sysi"))
#' simulate_registers("bef")
#' simulate_registers("diagnoser")
simulate_registers <- function(registers, n = 1000) {
  simulation_definitions <- fs::path_package(
    "osdc",
    "resources",
    "simulation-definitions.csv"
  ) |>
    readr::read_csv(show_col_types = FALSE) |>
    dplyr::select("register_abbrev", "variable_name", "generator")

  available_registers <- unique(simulation_definitions$register_abbrev)
  # All registers given have to be available.
  if (!all(registers %in% available_registers)) {
    cli::cli_abort(c(
      "The register{?s} {.val {registers}} {?is/are} not available in our list.",
      "i" = "We have these registers available: {.val {available_registers}}"
    ))
  }

  simulation_definitions_list <- simulation_definitions |>
    dplyr::filter(.data$register_abbrev %in% registers) |>
    dplyr::group_split(.data$register_abbrev)

  simulation_definitions_list |>
    purrr::map(\(data) create_simulated_data(data, n = n)) |>
    purrr::map(insert_specific_atc) |>
    purrr::map(insert_false_metformin) |>
    purrr::map(insert_analysiscode) |>
    purrr::map(fct_to_chr) |>
    # add the register abbreviations as a name to the list
    rlang::set_names(
      purrr::map_chr(
        simulation_definitions_list,
        \(data) unique(data$register_abbrev)
      )
    ) |>
    purrr::map(duckplyr::as_duckdb_tibble)
}
