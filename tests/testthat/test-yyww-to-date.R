test_that("conversion works when 01-01 is Monday in week 1", {
  expect_equal(yyww_to_date("2439"), lubridate::ymd("2024-09-23"))
})

test_that("conversion works when 01-01 is Friday in week 52 of the prior year", {
  expect_equal(yyww_to_date("9307"), lubridate::ymd("1993-02-15"))
})

test_that("conversion works for week 53", {
  expect_equal(yyww_to_date("1853"), lubridate::ymd("2018-12-31"))
})

test_that("conversion works for zero-padded year and week (i.e., numbers < 10)", {
  expect_equal(yyww_to_date("0107"), lubridate::ymd("2001-02-12"))
})

test_that("conversion works for numeric one digit year", {
  # This could happen if the input was "0107" and has been converted to numeric
  expect_equal(yyww_to_date(107), lubridate::ymd("2001-02-12"))
})

test_that("conversion works for numeric year 2000", {
  expect_equal(yyww_to_date(0007), lubridate::ymd("2000-02-14"))
})

test_that("conversion works for multiple inputs", {
  expect_equal(yyww_to_date(c("0107", "2439")), lubridate::ymd("2001-02-12", "2024-09-23"))
})
