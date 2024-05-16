lab_forsker <- tibble::tribble(
  ~patient_cpr, ~samplingdate, ~analysiscode, ~value,
  "498718589803", "20220101", "NPU27300", 49,
  "498718589804", "20220101", "NPU27300", 47,
  # Duplicate patient_cpr but with the old units.
  "498718589803", "20220101", "NPU03835", 6.5,
  "498718589805", "20220101", "NPU03835", 6.5,
  "498718589806", "20220101", "NPU03835", 6.3,
  "498718589807", "20220101", "NPU00000", 100,
  "498718589808", "20220101", "NPU00000", 5
)

expected <- tibble::tribble(
  ~pnr, ~include_hba1c,
  "498718589803", TRUE,
  "498718589803", TRUE,
  "498718589805", TRUE
)

test_that("dataset needs expected variables", {
  actual <- lab_forsker |>
    select(-patient_cpr)
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
