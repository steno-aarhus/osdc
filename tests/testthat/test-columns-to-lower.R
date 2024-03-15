data <- tibble::tibble(
  XY = 1:3,
  X_Y = 1:3,
  X_y3 = 1:3,
  y = 1:3
)
expected <- c("xy", "x_y", "x_y3", "y")

test_that("columns are correctly converted to lowercase", {
  actual <- data |>
    column_names_to_lower() |>
    names()

  expect_equal(actual, expected)
})

test_that("columns are converted for DuckDB Database", {
  actual <- arrow::to_duckdb(data) |>
    column_names_to_lower() |>
    # DuckDB needs to use `colnames()`
    colnames()

  expect_equal(actual, expected)
})

test_that("columns are converted for Arrow Tables (from Parquet)", {
  actual <- arrow::as_arrow_table(data) |>
    column_names_to_lower() |>
    names()

  expect_equal(actual, expected)
})

test_that("columns are converted for data.frame", {
  actual <- as.data.frame(data) |>
    column_names_to_lower() |>
    names()

  expect_equal(actual, expected)
})

test_that("columns are converted for data.table", {
  actual <- data.table::as.data.table(data) |>
    column_names_to_lower() |>
    names()

  expect_equal(actual, expected)
})
