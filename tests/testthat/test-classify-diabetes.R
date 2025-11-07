register_names <- registers() |>
  names()

# Create a larger synthetic dataset to test backends
register_data <- register_names |>
  simulate_registers(n = 10000)

test_that("expected cases are classified correctly", {
  skip()
  edge_case_data <- edge_cases()

  actual_included <- classify_diabetes(
    kontakter = edge_case_data$kontakter,
    diagnoser = edge_case_data$diagnoser,
    lpr_diag = edge_case_data$lpr_diag,
    lpr_adm = edge_case_data$lpr_adm,
    sysi = edge_case_data$sysi,
    sssy = edge_case_data$sssy,
    lab_forsker = edge_case_data$lab_forsker,
    bef = edge_case_data$bef,
    lmdb = edge_case_data$lmdb
  ) |>
    dplyr::arrange(pnr)

  expected_included <- edge_case_data$classified

  expect_identical(actual_included, expected_included)
})
test_that("expected non-cases are not classified", {
  nc_base <- non_cases()

  nc <- register_names |>
    purrr::map(\(name) {
      out <- list(
        dplyr::bind_rows(nc_base[[name]], register_data[[name]])
      )
      out <- rlang::set_names(out, name)
    }) |>
    purrr::flatten()

  actual <- classify_diabetes(
    kontakter = nc$kontakter,
    diagnoser = nc$diagnoser,
    lpr_diag = nc$lpr_diag,
    lpr_adm = nc$lpr_adm,
    sysi = nc$sysi,
    sssy = nc$sssy,
    lab_forsker = nc$lab_forsker,
    bef = nc$bef,
    lmdb = nc$lmdb
  )

  nc_pnrs <- names(non_cases_metadata())
  # No PNRs from non-cases have been classified.
  expected_pnrs <- actual |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expect_identical(expected_pnrs, character(0))
})


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
  # This issue happens in the `drop_pcos()` function.
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

test_that("casing of input variables doesn't matter", {
  # Testing this for data.frame input only here.
  registers_as_df <- register_data |>
    purrr::map(as.data.frame) |>
    # Convert column names to upper case.
    purrr::map(~ setNames(.x, toupper(names(.x))))

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
  )

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
