lab_forsker <- tibble::tribble(
  ~patient_cpr, ~samplingdate, ~analysiscode, ~value,
  # Three events, so only earliest two should be kept.
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
  "498718589809", "20220101", "NPU00000", 5
)

expected <- tibble::tribble(
  ~pnr, ~date, ~included_hba1c,
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
  actual <- lab_forsker
  expect_error(include_hba1c(actual))
})

test_that("those with inclusion are kept", {
  actual <- include_hba1c(lab_forsker)
  expect_equal(actual, expected)
})

test_that("casing of input variables doesn't matter", {
  actual <- lab_forsker |>
    rename_with(\(columns) toupper(columns)) |>
    include_hba1c()
  expect_equal(actual, expected)
})

test_that("verification works for DuckDB Database", {
  actual <- arrow::to_duckdb(lab_forsker) |>
    include_hba1c()

  expect_equal(actual, expected)
})

test_that("verification works for Arrow Tables (from Parquet)", {
  actual <- arrow::as_arrow_table(lab_forsker) |>
    include_hba1c()

  expect_equal(actual, expected)
})

test_that("verification works for data.frame", {
  actual <- as.data.frame(lab_forsker) |>
    include_hba1c()

  expect_equal(actual, expected)
})

test_that("verification works for data.table", {
  actual <- data.table::as.data.table(lab_forsker) |>
    include_hba1c()

  expect_equal(actual, expected)
})
