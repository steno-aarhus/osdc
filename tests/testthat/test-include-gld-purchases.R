constants <- tibble::tibble(
  pnr = "2132131231",
  eksd = "20210101",
  volume = 1.1,
  apk = 1.1,
  indo = "324314324",
  name = "random",
  vnr = "123123"
)

lmdb <- tibble::tribble(
  ~atc,
  "A10abc",
  "A10",
  "A10123",
  "A11",
  "A21",
  "B10A10",
) |>
  dplyr::bind_cols(constants)

expected <- tibble::tribble(
  ~atc,
  "A10abc",
  "A10",
  "A10123",
) |>
  dplyr::bind_cols(constants) |>
  dplyr::rename(date = eksd) |>
  dplyr::relocate(atc, .after = date)

test_that("dataset needs expected variables", {
  actual <- lmdb[-2]
  expect_error(include_gld_purchases(actual))
})

test_that("those with inclusion are kept", {
  actual <- include_gld_purchases(lmdb)
  expect_equal(actual, expected)
})

test_that("casing of input variables doesn't matter", {
  actual <- lmdb |>
    dplyr::rename_with(\(columns) toupper(columns)) |>
    include_gld_purchases()
  expect_equal(actual, expected)
})

test_that("verification works for DuckDB Database", {
  skip_on_cran()
  skip_if_not_installed("duckplyr")
  actual <- duckplyr::as_duckplyr_tibble(lmdb) |>
    include_gld_purchases()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})

test_that("verification works for Arrow Tables (from Parquet)", {
  skip_on_cran()
  skip_if_not_installed("arrow")
  actual <- arrow::as_arrow_table(lmdb) |>
    include_gld_purchases()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  # TODO: Arrow doesn't work with colname(), fix?
  expect_equal(names(actual), colnames(expected))
})

test_that("verification works for data.frame", {
  actual <- as.data.frame(lmdb) |>
    include_gld_purchases()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})

test_that("verification works for data.table", {
  skip_on_cran()
  skip_if_not_installed("data.table")
  actual <- data.table::as.data.table(lmdb) |>
    include_gld_purchases()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})
