test_that("date correctly converts to real dates for end and start of year", {
  # Using real dates from https://en.wikipedia.org/wiki/ISO_week_date
  input <- data.frame(
    date = c("0701", "0953", "0852")
  ) |>
    duckplyr::as_duckdb_tibble() |>
    duckplyr::as_tbl()

  expected <- lubridate::ymd("2007-01-01", "2009-12-28", "2008-12-22")

  actual <- input |>
    yyww_to_yyyymmdd() |>
    dplyr::collect() |>
    dplyr::pull(.data$date)

  expect_equal(expected, actual)
})

test_that("conversion works when date is numeric", {
  # This could happen if the input was "0107" and has been converted to numeric
  input_numeric <- data.frame(
    date = c("701", "953", "852")
  ) |>
    duckplyr::as_duckdb_tibble() |>
    duckplyr::as_tbl()

  expected <- lubridate::ymd("2007-01-01", "2009-12-28", "2008-12-22")

  actual_from_numeric <- input_numeric |>
    yyww_to_yyyymmdd() |>
    dplyr::collect() |>
    dplyr::pull(.data$date)

  expect_equal(expected, actual_from_numeric)
})
