test_that("conversion works for one digit week", {
  expect_equal(wwyy_to_date("798"), lubridate::ymd("1998-02-09"))
})

test_that("conversion works when 01-01 is Monday in week 1", {
  expect_equal(wwyy_to_date("3924"), lubridate::ymd("2024-09-23"))
})

test_that("conversion works when 01-01 is Friday in week 52 of the prior year", {
  expect_equal(wwyy_to_date("0793"), lubridate::ymd("1993-02-15"))
})

test_that("conversion works for week 53 in 2018", {
  expect_equal(wwyy_to_date("5318"), lubridate::ymd("2018-12-31"))
})

