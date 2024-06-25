# join_lpr2 -----------------------------------------------------------------

actual_lpr_diag <- tibble::tibble(
  recnum = rep(1:6, each = 2),
  c_diag = 1:12,
  c_diagtype = rep(c("A", "B"), 6)
)

actual_lpr_adm <- tibble::tibble(
  pnr = rep(1:2, 3),
  recnum = 2:7,
  c_spec = 1:6,
  d_inddto = c("20230101", "20220101", "20210101", "20200101", "20190101", "20180101"),
)

expected_lpr2 <- tibble::tibble(
  pnr = rep(1:2, length.out = 10, each = 2),
  recnum = rep(2:6, length.out = 10, each = 2),
  c_spec = rep(1:5, length.out = 10, each = 2),
  d_inddto = rep(c("20230101", "20220101", "20210101", "20200101", "20190101"), each = 2),
  c_diag = 3:12,
  c_diagtype = rep(c("A", "B"), length.out = 10)
)

test_that("joining LPR2 correctly", {
  actual <- join_lpr2(
    actual_lpr_adm,
    actual_lpr_diag
  )

  expect_equal(actual, expected_lpr2)
})

test_that("lpr_adm and lpr_diag must be in correct arg position", {
  expect_error(join_lpr2(
    actual_lpr_diag,
    actual_lpr_adm
  ))
})

test_that("joining works for DuckDB Database", {
  actual <- arrow::to_duckdb(actual_lpr_adm) |>
    join_lpr2(arrow::to_duckdb(actual_lpr_diag))

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "tbl_duckdb_connection")
  expect_identical(colnames(actual), colnames(expected_lpr2))
  expect_identical(actual_rows, nrow(expected_lpr2))
})

test_that("joining works for Arrow Tables (from Parquet)", {
  actual <- arrow::as_arrow_table(actual_lpr_adm) |>
    join_lpr2(arrow::as_arrow_table(actual_lpr_diag))

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "arrow_dplyr_query")
  expect_identical(names(actual), colnames(expected_lpr2))
  expect_identical(actual_rows, nrow(expected_lpr2))
})

test_that("joining works for data.frame", {
  actual <- as.data.frame(actual_lpr_adm) |>
    join_lpr2(as.data.frame(actual_lpr_diag))

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  expect_identical(names(actual), colnames(expected_lpr2))
  expect_identical(actual_rows, nrow(expected_lpr2))
})

test_that("joining works for data.table", {
  actual <- data.table::as.data.table(actual_lpr_adm) |>
    join_lpr2(data.table::as.data.table(actual_lpr_diag))

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.table")
  expect_identical(colnames(actual), colnames(expected_lpr2))
  expect_identical(actual_rows, nrow(expected_lpr2))
})

# join_lpr3 -----------------------------------------------------------------

actual_diagnoser <- tibble::tibble(
  dw_ek_kontakt = 1:4,
  diagnosekode = rep(c("DA071","DD075"), times = 2),
  diagnosetype = rep(c("A", "B"), times = 2),
  senere_afkraeftet = rep(c("Nej", "Ja"), times = 2)
)

actual_kontakter <- tibble::tibble(
  cpr = c(1, 1, 2, 3),
  dw_ek_kontakt = 2:5,
  dato_start = c("20230101", "20220101", "20200101", "20200101"),
  hovedspeciale_ans = c("Neurologi", "Akut medicin", "Kardiologi", "Neurologi")
)

expected_lpr3 <- tibble::tibble(
  cpr = c(1, 1, 2),
  dw_ek_kontakt = 2:4,
  dato_start = c("20230101", "20220101", "20200101"),
  hovedspeciale_ans = c("Neurologi", "Akut medicin", "Kardiologi"),
  diagnosekode = c("DD075","DA071", "DD075"),
  diagnosetype = c("B", "A", "B"),
  senere_afkraeftet = c("Ja", "Nej", "Ja")
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
