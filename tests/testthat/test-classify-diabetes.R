register_data <- simulate_registers(
  c(
    "kontakter",
    "diagnoser",
    "lpr_diag",
    "lpr_adm",
    "sysi",
    "sssy",
    "lab_forsker",
    "bef",
    "lmdb"
  ),
  n = 10000
)

# TODO: eventually add code here that tests that specific "people" who we
# set as having diabetes in the input data actually get correctly classified
# in the output data.

test_that("classifying works with DuckDB Database", {
  skip_on_cran()
  skip_if_not_installed("duckplyr")
  registers_as_ddb <- register_data |>
    purrr::map(duckplyr::as_duckdb_tibble)

  actual <- classify_diabetes(
    kontakter = registers_as_ddb$kontakter,
    diagnoser = registers_as_ddb$diagnoser,
    lpr_diag = registers_as_ddb$lpr_diag,
    lpr_adm = registers_as_ddb$lpr_adm,
    sysi = registers_as_ddb$sysi,
    sssy = registers_as_ddb$sssy,
    lab_forsker = registers_as_ddb$lab_forsker,
    bef = registers_as_ddb$bef,
    lmdb = registers_as_ddb$lmdb
  ) |>
    dplyr::compute()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )
  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "duckplyr_df")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for Arrow Tables (from Parquet)", {
  # TODO: Currently, Arrow fails bc it can't handle doing a comparison (<)
  # between two different types (date - foed_dato is a duration; years(40) is
  # a period) in the logic.
  # This issue happens in the `exclude_potential_pcos()` function.
  # I've also tried converting date, foed_dato, and 40 years to
  # numbers before the comparison, but it still fails bc arrow can't cast date32
  # to a double directly.
  skip()
  skip_on_cran()
  skip_if_not_installed("arrow")
  registers_as_arrow <- register_data |>
    purrr::map(arrow::as_arrow_table)

  actual <- classify_diabetes(
    kontakter = registers_as_arrow$kontakter,
    diagnoser = registers_as_arrow$diagnoser,
    lpr_diag = registers_as_arrow$lpr_diag,
    lpr_adm = registers_as_arrow$lpr_adm,
    sysi = registers_as_arrow$sysi,
    sssy = registers_as_arrow$sssy,
    lab_forsker = registers_as_arrow$lab_forsker,
    bef = registers_as_arrow$bef,
    lmdb = registers_as_arrow$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "Table")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for data.frame", {
  registers_as_df <- register_data |>
    purrr::map(as.data.frame)

  actual <- classify_diabetes(
    kontakter = registers_as_df$kontakter,
    diagnoser = registers_as_df$diagnoser,
    lpr_diag = registers_as_df$lpr_diag,
    lpr_adm = registers_as_df$lpr_adm,
    sysi = registers_as_df$sysi,
    sssy = registers_as_df$sssy,
    lab_forsker = registers_as_df$lab_forsker,
    bef = registers_as_df$bef,
    lmdb = registers_as_df$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})

test_that("classifying works for data.table", {
  skip_on_cran()
  skip_if_not_installed("data.table")
  registers_as_dt <- register_data |>
    purrr::map(data.table::as.data.table)

  actual <- classify_diabetes(
    kontakter = registers_as_dt$kontakter,
    diagnoser = registers_as_dt$diagnoser,
    lpr_diag = registers_as_dt$lpr_diag,
    lpr_adm = registers_as_dt$lpr_adm,
    sysi = registers_as_dt$sysi,
    sssy = registers_as_dt$sssy,
    lab_forsker = registers_as_dt$lab_forsker,
    bef = registers_as_dt$bef,
    lmdb = registers_as_dt$lmdb
  ) |>
    dplyr::collect()

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_contains(class(actual), "data.frame")
  # expect_identical(colnames(actual), expected_columns)
  # expect_identical(actual_rows, expected_rows)
})
