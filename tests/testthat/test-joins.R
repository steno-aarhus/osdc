# join_lpr2 -----------------------------------------------------------------

actual_lpr_diag <- tibble::tibble(
  recnum = c(1:2),
  c_diag = 1:2,
  c_diagtype = c("A", "B")
)

actual_lpr_adm <- tibble::tibble(
  pnr = 1:3,
  recnum = c(1, 1, 2),
  c_spec = 1:3,
  d_inddto = c("20230101", "20220101", "20200101"),
)

expected_lpr2 <- tibble::tibble(
  pnr = 1:3,
  recnum = c(1, 1, 2),
  c_spec = 1:3,
  d_inddto = c("20230101", "20220101", "20200101"),
  c_diag = c(1, 1, 2),
  c_diagtype = c("A", "A", "B"),
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

# join_lpr3 -----------------------------------------------------------------

actual_diagnoser <- tibble::tibble(
  dw_ek_kontakt = 1:2,
  diagnosekode = c("DA071","DD075"),
  diagnosetype = c("A", "B"),
  senere_afkraefter = c("Nej", "Ja")
)

actual_kontakter <- tibble::tibble(
  cpr = c(1, 1, 2),
  dw_ek_kontakt = 1:3,
  dato_start = c("20230101", "20220101", "20200101"),
  hovedspaciale_ans = c("Neurologi", "Akut medicin", "Kardiologi"),
)

expected_lpr3 <- tibble::tibble(
  cpr = c(1, 1, 2),
  dw_ek_kontakt = c(1,2,3),
  dato_start = c("20230101", "20220101", "20200101"),
  hovedspaciale_ans = c("Neurologi", "Akut medicin", "Kardiologi"),
  diagnosekode = c("DA071","DD075", NA),
  diagnosetype = c("A", "B", NA),
  senere_afkraefter = c("Nej", "Ja", NA),
)

test_that("joining LPR3 correctly", {
  actual <- join_lpr3(
    actual_diagnoser,
    actual_kontakter
  )

  expect_equal(actual, expected_lpr3)
})

test_that("joining works for DuckDB Database", {
  actual <- arrow::to_duckdb(actual_diagnoser) |>
    join_lpr3(arrow::to_duckdb(actual_kontakter))

  expect_contains(class(actual), "tbl_duckdb_connection")
})

test_that("joining works for Arrow Tables (from Parquet)", {
  actual <- arrow::as_arrow_table(actual_diagnoser) |>
    join_lpr3(arrow::as_arrow_table(actual_kontakter))

  expect_contains(class(actual), "arrow_dplyr_query")
})

test_that("joining works for data.frame", {
  actual <- as.data.frame(actual_diagnoser) |>
    join_lpr3(as.data.frame(actual_kontakter))

  expect_contains(class(actual), "data.frame")
})

test_that("joining works for data.table", {
  actual <- data.table::as.data.table(actual_diagnoser) |>
    join_lpr3(data.table::as.data.table(actual_kontakter))

  expect_contains(class(actual), "data.table")
})
