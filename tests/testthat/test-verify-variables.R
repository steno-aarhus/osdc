library(tibble)

bef_complete <- tibble::tibble(pnr = 1, koen = 1, foed_dato = 1)

test_that("the correct abbreviation for the register is used", {
  # When incorrect register abbreviation is given
  expect_error(verify_required_variables(bef_complete, "bef1"))
  # When correct abbreviation is given
  expect_true(verify_required_variables(bef_complete, "bef"))
})

test_that("the required variables are present in the dataset", {
  # Expected
  bef_complete_extra <- tibble(pnr = 1, koen = 1, foed_dato = 1, something = 1)
  bef_incomplete <- tibble(pnr = 1, koen = 1)

  # When all variables are the required variables
  expect_true(verify_required_variables(bef_complete, "bef"))

  # When some of the variables are the required variables
  expect_true(verify_required_variables(bef_complete_extra, "bef"))

  expect_error(verify_required_variables(bef_incomplete, "bef"))
})


test_that("verification works for DuckDB Database", {
  skip_on_cran()
  skip_if_not_installed("duckplyr")
  actual <- duckplyr::as_duckdb_tibble(bef_complete) |>
    verify_required_variables("bef")

  expect_true(actual)
})

test_that("verification works for Arrow Tables (from Parquet)", {
  skip_on_cran()
  skip_if_not_installed("arrow")
  actual <- arrow::as_arrow_table(bef_complete) |>
    verify_required_variables("bef")

  expect_true(actual)
})

test_that("verification works for data.frame", {
  actual <- as.data.frame(bef_complete) |>
    verify_required_variables("bef")

  expect_true(actual)
})

test_that("verification works for data.table", {
  skip_on_cran()
  skip_if_not_installed("data.table")
  actual <- data.table::as.data.table(bef_complete) |>
    verify_required_variables("bef")

  expect_true(actual)
})
