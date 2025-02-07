test_that("date correctly converts to real dates for end and start of year", {
  # Using real dates from https://en.wikipedia.org/wiki/ISO_week_date
  expected <- lubridate::ymd("2007-01-01", "2009-12-28", "2008-12-22")
  actual <- yyww_to_yyyymmdd(c("0701", "0953", "0852"))
  expect_equal(expected, actual)
})

test_that("conversion works when date is numeric", {
  # This could happen if the input was "0107" and has been converted to numeric
  expect_equal(yyww_to_yyyymmdd(107), lubridate::ymd("2001-02-12"))
  expect_equal(yyww_to_yyyymmdd(7), lubridate::ymd("2000-02-14"))
})
