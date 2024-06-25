actual_lpr_diag <- tibble::tibble(
  recnum = rep(1:4, each = 2),
  c_diag = 1:8,
  c_diagtype = rep(c("A", "B"), 4)
)

actual_lpr_adm <- tibble::tibble(
  pnr = rep(1:2, 2),
  recnum = 1:4,
  c_spec = 1:4,
  d_inddto = c("20230101", "20220101", "20210101", "20200101"),
)

expected_lpr2 <- tibble::tibble(
  pnr = rep(1:2, 2, each = 2),
  recnum = rep(1:4, each = 2),
  c_spec = rep(1:4, each = 2),
  d_inddto = rep(c("20230101", "20220101", "20210101", "20200101"), each = 2),
  c_diag = 1:8,
  c_diagtype = rep(c("A", "B"), 4)
)

test_that("joining LPR2 correctly", {
  actual <- join_lpr2(
    actual_lpr_diag,
    actual_lpr_adm
  )

  expect_equal(actual, expected_lpr2)
})

test_that("joining works for DuckDB Database", {
  actual <- arrow::to_duckdb(actual_lpr_diag) |>
    join_lpr2(arrow::to_duckdb(actual_lpr_adm))

  expect_contains(class(actual), "tbl_duckdb_connection")
})

test_that("joining works for Arrow Tables (from Parquet)", {
  actual <- arrow::as_arrow_table(actual_lpr_diag) |>
    join_lpr2(arrow::as_arrow_table(actual_lpr_adm))

  expect_contains(class(actual), "arrow_dplyr_query")
})

test_that("joining works for data.frame", {
  actual <- as.data.frame(actual_lpr_diag) |>
    join_lpr2(as.data.frame(actual_lpr_adm))

  expect_contains(class(actual), "data.frame")
})

test_that("joining works for data.table", {
  actual <- data.table::as.data.table(actual_lpr_diag) |>
    join_lpr2(data.table::as.data.table(actual_lpr_adm))

  expect_contains(class(actual), "data.table")
})
