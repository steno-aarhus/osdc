#' Simple function to get only the pregnancy event dates.
#'
#' @param lpr2 Output from `join_lpr2()`.
#' @param lpr3 Output from `join_lpr3()`.
#'
#' @returns The same type as the input data, as a [duckplyr::duckdb_tibble()].
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
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()],
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
    dplyr::filter(.data$is_diabetes_code) |>
    # Add logical helper variable to indicate a diabetes diagnosis.
    dplyr::mutate(has_diabetes_diagnosis = TRUE)
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
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
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
    ) |>
    # Add logical helper variable to indicate a gld purchase.
    dplyr::mutate(has_gld_purchase = TRUE)
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
#' @return An object of the same input type, as a [duckplyr::duckdb_tibble()],
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
    dplyr::distinct() |>
    # Add logical helper value to indicate elevated HbA1c. Also used to remove
    # HbA1c rows when insulin purchases columns are added later.
    dplyr::mutate(has_hba1c_over_threshold = TRUE)
}

#' Keep rows with diabetes-specific podiatrist services.
#'
#' This function uses the `sysi` or `sssy` registers as input to extract the
#' dates of all diabetes-specific podiatrist services. Removes duplicate
#' services on the same date.
#'
#' The output is passed to the `join_inclusions()` function for the final
#' step of the inclusion process.
#'
#' @param sysi The SYSI register.
#' @param sssy The SSSY register.
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
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
    # Both of these need to be converted to correct format.
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
    # Add logical helper variable to indicate diabetes-related podiatrist service.
    dplyr::mutate(has_podiatrist_service = TRUE)
}

#' Convert date format YYWW to YYYY-MM-DD
#'
#' Since the exact date isn't given in the input, this function will set the
#' date to Monday of the week. As a precaution, a leading zero is added if it
#' has been removed. This can e.g., happen if the input was "0107" and has been
#' converted to a numeric 107.
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

#' Keep two earliest events per PNR
#'
#' Since the classification date is based on the second instance of
#' an inclusion criteria, we only need to keep the earliest two events per PNR
#' per inclusion "stream".
#'
#' This function is applied to each "stream", `diabetes_diagnoses`,
#' `podiatrist_services`, and `gld_hba1c_after_drop_steps`, in  the
#' `classify_diabetes()` function after the keep and drop steps, right before
#'  they are joined.
#'
#' @param data Data including at least a date and pnr column.
#'
#' @returns The same type as the input data.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' data <- tibble::tribble(
#'   ~pnr, ~date,
#'   1, "20200101",
#'   1, "20200102",
#'   1, "20200103",
#'   2, "20200101"
#' )
#' keep_two_earliest_events(data)
#' }
keep_two_earliest_events <- function(data) {
  data |>
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2, .by = "pnr")
}
