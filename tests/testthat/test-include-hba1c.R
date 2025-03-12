lab_forsker <- tibble::tribble(
  ~patient_cpr, ~samplingdate, ~analysiscode, ~value,
  # Three events, all of which should be kept (except duplicates)
  "498718589800", "20230101", "NPU27300", 49,
  "498718589800", "20210101", "NPU27300", 49,
  "498718589800", "20220101", "NPU27300", 49,
  "498718589801", "20230101", "NPU03835", 6.6,
  "498718589802", "20230101", "NPU03835", 6.3,
  "498718589803", "20230101", "NPU27300", 47,
  # Duplicate patient_cpr but with the old units.
  "498718589803", "20210101", "NPU27300", 49,
  "498718589803", "20220101", "NPU03835", 6.5,
  # Duplicate patient_cpr when old and new units are the same date.
  "498718589805", "20000101", "NPU03835", 6.5,
  "498718589805", "20000101", "NPU27300", 49,
  # Duplicate but with old below threshold and new above it.
  "498718589806", "20000101", "NPU03835", 6.3,
  "498718589806", "20000101", "NPU27300", 49,
  # Duplicate but with new below threshold and old above it.
  "498718589807", "20200101", "NPU03835", 6.6,
  "498718589807", "20200101", "NPU27300", 47,
  "498718589808", "20220101", "NPU00000", 100,
  "498718589809", "20220101", "NPU00000", 5,
  # If there are NA values, they should be ignored.
  "498718589809", "20220101", "NPU00000", NA,
  "498718589809", "20220101", NA, 5,
  "498718589809", NA, "NPU00000", 5,
  NA, "20220101", "NPU00000", 5
)

expected <- tibble::tribble(
  ~pnr, ~date, ~has_elevated_hba1c,
  "498718589800", "20230101", TRUE,
  "498718589800", "20210101", TRUE,
  "498718589800", "20220101", TRUE,
  "498718589801", "20230101", TRUE,
  "498718589803", "20210101", TRUE,
  "498718589803", "20220101", TRUE,
  "498718589805", "20000101", TRUE,
  "498718589806", "20000101", TRUE,
  "498718589807", "20200101", TRUE
)

test_that("dataset needs expected variables", {
  actual <- lab_forsker[-2]
  expect_error(include_hba1c(actual))
})

test_that("those with inclusion are kept", {
  actual <- include_hba1c(lab_forsker)
  expect_equal(actual, expected)
})

test_that("casing of input variables doesn't matter", {
  actual <- lab_forsker |>
    dplyr::rename_with(\(columns) toupper(columns)) |>
    include_hba1c()
  expect_equal(actual, expected)
})

test_that("verification works for DuckDB Database", {
  skip_on_cran()
  skip_if_not_installed("duckplyr")
  actual <- duckplyr::as_duckdb_tibble(lab_forsker) |>
    include_hba1c()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})

test_that("verification works for Arrow Tables (from Parquet)", {
  skip_on_cran()
  skip_if_not_installed("arrow")
  actual <- arrow::as_arrow_table(lab_forsker) |>
    include_hba1c() |> dplyr::compute()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})

test_that("verification works for data.frame", {
  actual <- as.data.frame(lab_forsker) |>
    include_hba1c()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})

test_that("verification works for data.table", {
  skip_on_cran()
  skip_if_not_installed("data.table")
  actual <- data.table::as.data.table(lab_forsker) |>
    include_hba1c()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n)

  expect_equal(actual_rows, nrow(expected))
  expect_equal(colnames(actual), colnames(expected))
})
