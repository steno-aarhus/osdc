#' Simple function to get only the pregnancy event dates.
#'
#' @param lpr2 Output from `join_lpr2()`.
#' @param lpr3 Output from `join_lpr3()`.
#'
#' @returns The same type as the input data, default as a [tibble::tibble()].
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(
#'   c("lpr_adm", "lpr_diag", "kontakter", "diagnoser"),
#'   n = 1000
#' )
#' lpr2 <- prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag)
#' lpr3 <- prepare_lpr3(register_data$diagnoser, register_data$kontakter)
#' keep_pregnancy_dates(lpr2, lpr3)
#' }
keep_pregnancy_dates <- function(lpr2, lpr3) {
  lpr2 |>
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(.data$is_pregnancy_code) |>
    dplyr::select(
      "pnr",
      "pregnancy_event_date" = date
    ) |>
    # Remove potential duplicates.
    dplyr::distinct() |>
    # Add logical helper variable to indicate pregnancy events.
    dplyr::mutate(has_pregnancy_event = TRUE)
}

#' Keep rows with diabetes diagnoses.
#'
#' This function uses the hospital contacts from LPR2 and LPR3 to include all
#' dates of diabetes diagnoses to use for inclusion, as well as
#' additional information needed to classify diabetes type.
#' Diabetes diagnoses from both ICD-8 and ICD-10 are included.
#'
#' @param lpr2 The output from [prepare_lpr2()].
#' @param lpr3 The output from [prepare_lpr3()].
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'  with less rows after filtering.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"))
#' keep_diabetes_diagnoses(
#'   lpr2 = prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
#'   lpr3 = prepare_lpr3(register_data$kontakter, register_data$diagnoser)
#' )
#' }
keep_diabetes_diagnoses <- function(lpr2, lpr3) {
  # Combine and process the two inputs
  lpr2 |>
    dplyr::bind_rows(lpr3) |>
    dplyr::filter(.data$is_diabetes_code)
}

#' Keep rows with purchases of glucose lowering drugs (GLD)
#'
#' This function doesn't keep glucose-lowering drugs that may be used for other
#' conditions than diabetes like GLP-RAs or dapagliflozin/empagliflozin drugs.
#' Since the diagnosis code data on pregnancies (see below) is insufficient to
#' perform censoring prior to 1997, [keep_gld_purchases()] only extracts
#' dates from 1997 onward by default (if Medical Birth Register data is
#' available to use for censoring, the extraction window can be extended).
#'
#' @param lmdb The `lmdb` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'   Only rows with glucose lowering drug purchases are kept, plus some columns are renamed.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' simulate_registers("lmdb", 1000)[[1]] |> keep_gld_purchases()
#' }
keep_gld_purchases <- function(lmdb) {
  logic <- c(
    "is_gld_code"
  ) |>
    logic_as_expression()

  lmdb |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic$is_gld_code) |>
    # Rename columns for clarity.
    dplyr::rename(
      date = "eksd",
      indication_code = "indo"
    )
}

#' Keep rows with HbA1c above the required threshold.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT). Multiple elevated results on the
#' same day within each individual are deduplicated, to account for the same
#' test result often being reported twice (one for IFCC, one for DCCT units).
#'
#' The output is passed to the `drop_pregnancies()` function for
#' filtering of elevated results due to potential gestational diabetes (see
#' below).
#'
#' @param lab_forsker The `lab_forsker` register.
#'
#' @return An object of the same input type, default as a [tibble::tibble()],
#'   with three columns:
#'
#'   - `pnr`: Personal identification variable.
#'   - `dates`: The dates of all elevated HbA1c test results.
#'
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' simulate_registers("lab_forsker", 100)[[1]] |> keep_hba1c()
#' }
keep_hba1c <- function(lab_forsker) {
  logic <- logic_as_expression("is_hba1c_over_threshold")[[1]]

  lab_forsker |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic) |>
    # Keep only the columns we need.
    dplyr::mutate(
      pnr = .data$patient_cpr,
      date = .data$samplingdate,
      .keep = "none"
    ) |>
    # Remove any duplicates
    dplyr::distinct()
}

#' Keep rows with diabetes-specific podiatrist services.
#'
#' This function uses the `sysi` or `sssy` registers as input to extract the
#' dates of all diabetes-specific podiatrist services. Removes duplicate
#' services on the same date. Only the two earliest dates per individual are
#' kept.
#'
#' The output is passed to the `join_inclusions()` function for the final
#' step of the inclusion process.
#'
#' @param sysi The SYSI register.
#' @param sssy The SSSY register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()],
#'   with two columns and up to two rows for each individual:
#'
#'   -  `pnr`: Identifier variable
#'   -  `date`: The dates of the first and second diabetes-specific
#'      podiatrist record
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("sysi", "sssy"), 100)
#' keep_(register_data$sysi, register_data$sssy)
#' }
keep_podiatrist_services <- function(sysi, sssy) {
  logic <- logic_as_expression("is_podiatrist_services")[[1]]

  sysi |>
    dplyr::full_join(
      sssy,
      by = dplyr::join_by("pnr", "barnmak", "speciale", "honuge")
    ) |>
    # Both of these need to be converted to correct format in order for
    # Arrow to correctly filter them later.
    dplyr::mutate(
      speciale = as.character(.data$speciale),
      barnmak = as.integer(.data$barnmak)
    ) |>
    # Filter based algorithm logic.
    dplyr::filter(!!logic) |>
    # Remove duplicates
    dplyr::distinct() |>
    # Keep only the two columns we need and transform `honuge` to YYYY-MM-DD.
    dplyr::mutate(
      pnr = .data$pnr,
      date = yyww_to_yyyymmdd(.data$honuge),
      .keep = "none"
    ) |>
    # Keep earliest two dates per individual.
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2, .by = "pnr")
}

#' Convert date format YYWW to YYYY-MM-DD
#'
#' Since the exact date isn't given in the input, this function will set the
#' date to Monday of the week. As a precaution, a leading zero is added if it
#' has been removed. This can e.g., happen if the input was "0107" and has been
#' converted to a numeric 107. We need to export this function so that it can
#' be found when using Arrow to process the data.
#'
#' @param yyww Character(s) of the format YYWW.
#'
#' @returns Date(s) in the format YYYY-MM-DD.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' yyww_to_yyyymmdd("0101")
#' yyww_to_yyyymmdd(c("0102", "0304"))
#' yyww_to_yyyymmdd(953)
#' }
yyww_to_yyyymmdd <- function(yyww) {
  if (is.numeric(yyww)) {
    # Ensure input is zero-padded to length 4.
    yyww <- sprintf("%04d", yyww)
  }

  # Extract year and week.
  year <- stringr::str_sub(yyww, 1, 2)
  week <- stringr::str_sub(yyww, 3, 4)

  # Calculate the first day of the ISO year, which is when the first week
  # has most of the week days in it (4th of January, or the first Thursday).
  # See: https://en.wikipedia.org/wiki/ISO_week_date
  year_start <- lubridate::ymd(paste(year, "-01-04"))
  first_weekday <- lubridate::wday(year_start, week_start = 1)

  # Create the date, using the start of year, but setting the week from the
  # `yyww` argument. This forces the date to move to the correct week.
  date <- year_start
  lubridate::week(date) <- as.numeric(week)

  # Adjust the date to be Monday in that week. Need to add 1 since there is
  # no zero weekday (week starts on 1, the Monday).
  date - first_weekday + 1
}
