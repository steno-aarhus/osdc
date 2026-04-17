#' Simple function to get only the pregnancy event dates.
#'
#' @inheritParams classify_diabetes
#'
#' @returns The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'
#' @noRd
#' @inherit algorithm seealso
keep_pregnancy_dates <- function(lpr) {
  lpr |>
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
#' @inheritParams classify_diabetes
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()],
#'  with less rows after filtering.
#'
#' @noRd
#' @inherit algorithm seealso
keep_diabetes_diagnoses <- function(lpr) {
  # Combine and process the two inputs
  lpr |>
    dplyr::filter(.data$is_diabetes_code) |>
    # Add logical helper variable to indicate a diabetes diagnosis.
    dplyr::mutate(from_diabetes_diagnosis = TRUE)
}

#' Keep rows with purchases of glucose lowering drugs (GLD)
#'
#' This function doesn't keep glucose-lowering drugs that may be used for other
#' conditions than diabetes like GLP-RAs or dapagliflozin/empagliflozin drugs.
#' Since the diagnosis code data on pregnancies (see below) is insufficient to
#' perform censoring prior to 1997, This function only extracts dates from 1997
#' onward by default (if Medical Birth Register data is available to use for
#' censoring, the extraction window can be extended).
#'
#' @param lmdb The `lmdb` register.
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'   Only rows with glucose lowering drug purchases are kept, plus some columns are renamed.
#'
#' @noRd
#' @inherit algorithm seealso
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
    dplyr::mutate(from_gld_purchase = TRUE)
}

#' Keep rows with HbA1c above the required threshold.
#'
#' In the `lab_forsker` register, NPU27300 is HbA1c in the modern units (IFCC)
#' while NPU03835 is HbA1c in old units (DCCT). Multiple elevated results on the
#' same day within each individual are deduplicated, to account for the same
#' test result often being reported twice (one for IFCC, one for DCCT units).
#'
#' @param lab_forsker The `lab_forsker` register.
#'
#' @return An object of the same input type, as a [duckplyr::duckdb_tibble()],
#'   with three columns:
#'
#'   - `pnr`: Personal identification variable.
#'   - `dates`: The dates of all elevated HbA1c test results.
#'
#' @noRd
keep_hba1c <- function(lab_forsker) {
  logic <- logic_as_expression("is_hba1c_over_threshold")[[1]]

  lab_forsker |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!logic) |>
    # Keep only the columns we need.
    dplyr::mutate(
      pnr = .data$pnr,
      date = .data$samplingdate,
      .keep = "none"
    ) |>
    # Remove any duplicates
    dplyr::distinct() |>
    # Add logical helper value to indicate elevated HbA1c. Also used to remove
    # HbA1c rows when insulin purchases columns are added later.
    dplyr::mutate(from_hba1c_over_threshold = TRUE)
}

#' Keep rows with diabetes-specific podiatrist services.
#'
#' @description
#' This function uses the `sysi` or `sssy` registers as input to extract the
#' dates of all diabetes-specific podiatrist services. Removes duplicate
#' services on the same date.
#'
#' @param hsr The unified health services registers (SYSI and SSSY), see
#'  [join_registers()].
#'
#' @return The same type as the input data, as a [duckplyr::duckdb_tibble()].
#'
#'   -  `pnr`: Identifier variable
#'   -  `date`: The dates of the first and second diabetes-specific
#'      podiatrist record
#'
#' @noRd
#' @inherit algorithm seealso
keep_podiatrist_services <- function(hsr) {
  logic <- logic_as_expression("is_podiatrist_services")[[1]]

  hsr |>
    # Both of these need to be converted to correct format.
    dplyr::mutate(
      speciale = as.character(.data$speciale),
      barnmak = as.integer(.data$barnmak)
    ) |>
    # Filter based algorithm logic.
    dplyr::filter(!!logic) |>
    # Remove duplicates
    dplyr::distinct() |>
    # Keep only the two columns we need.
    dplyr::select(
      "pnr",
      date = "honuge"
    ) |>
    # Add logical helper variable to indicate diabetes-related podiatrist service.
    # Transform date from yyww to YYYY-MM-DD.
    yyww_to_yyyymmdd() |>
    # Add logical helper variable to indicate diabetes-related podiatrist service.
    dplyr::mutate(from_podiatrist_service = TRUE)
}

#' Convert date format YYWW to YYYY-MM-DD
#'
#' Since the exact date isn't given in the input, this function will set the
#' date to Monday of the week. As a precaution, a leading zero is added if it
#' has been removed. This can e.g., happen if the input was "0107" and has been
#' converted to a numeric 107.
#'
#' @param data A DuckDB-backed data frame with a `date` column formatted as YYWW values.
#'
#' @returns a data frame containing a `date` column in the format YYYY-MM-DD.
#' @noRd
yyww_to_yyyymmdd <- function(data) {
  data |>
    # Ensure input from the honuge/date variable is zero-padded to length 4.
    dplyr::mutate(
      yyww_padded = dbplyr::sql("LPAD(CAST(date AS VARCHAR), 4, '0')"),
      # Extract year and week.
      # The way the year values are set up in the registers isn't Y2K-safe,
      # and by 2090 the values will overflow, and the data will be invalid.
      # There is nothing we can do about it, but DST will have to deal with it
      # at some point before 2090.
      yy = as.integer(substr(.data$yyww_padded, 1, 2)),
      ww = as.integer(substr(.data$yyww_padded, 3, 4)),
      full_year = dplyr::if_else(
        # Anything greater than YY 90 will be from the 1900s.
        .data$yy >= 90,
        # Place these in the 1990s.
        1900L + .data$yy,
        # Place any values below 90 in the 2000s.
        2000L + .data$yy
      ),
      # Calculate the first day of the ISO year, which is when the first week
      # has most of the week days in it (4th of January, or the first Thursday).
      # See https://en.wikipedia.org/wiki/ISO_week_date.
      jan4 = dbplyr::sql("MAKE_DATE(full_year, 1, 4)"),
      # Calculate the weekday of jan4 and the date of Monday of ISO-week 1.
      days_from_monday = dbplyr::sql("(DAYOFWEEK(jan4) + 6) % 7"),
      week1_monday = dbplyr::sql(
        "jan4 - (days_from_monday || ' days')::INTERVAL"
      )
    ) |>
    # Calculate the date of the Monday of the ISO week (`ww`)
    # Starting from `week1_monday` (the Monday of ISO week 1),
    # add (`ww-1`) weeks to reach the target week:
    # - `ww-1`: Number of weeks to offset from ISO week 1

    # - || ' weeks': Concatenates the offset with the text "weeks" to form a SQL interval string (e.g., "3 weeks")

    # - ::INTERVAL: Casts the string to an INTERVAL type.

    # The result is added to `week1_monday` and cast to DATE.
    dplyr::mutate(
      date = dbplyr::sql(
        "CAST(week1_monday + ((ww - 1) || ' weeks')::INTERVAL AS DATE)"
      )
    ) |>
    # Drop intermediate calculation columns.
    dplyr::select(
      -c(
        "yyww_padded",
        "yy",
        "ww",
        "full_year",
        "jan4",
        "days_from_monday",
        "week1_monday"
      )
    )
}

#' Keep two earliest events per PNR
#'
#' @description
#' Since the classification date is based on the second instance of
#' an inclusion criteria, we need to keep the earliest two events per PNR
#' per inclusion "stream".
#'
#' This function is applied to each "stream", `diabetes_diagnoses`,
#' `podiatrist_services`, and `gld_hba1c_after_drop_steps`, in  the
#' [classify_diabetes()] function after the keep and drop steps, right before
#'  they are joined.
#'
#' @param data Data including at least a date and pnr column.
#'
#' @returns The same type as the input data.
#' @noRd
keep_two_earliest_events <- function(data) {
  data |>
    dplyr::filter(dplyr::row_number(.data$date) %in% 1:2, .by = "pnr")
}
