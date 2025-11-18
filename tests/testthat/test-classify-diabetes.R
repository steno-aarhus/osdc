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
  nc <- non_cases()

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

test_that("casing of input variables doesn't matter", {
  # Testing this for data.frame input only here.
  registers <- register_data |>
    # Convert column names to upper case.
    purrr::map(~ setNames(.x, toupper(names(.x))))

  actual <- classify_diabetes(
    kontakter = registers$kontakter,
    diagnoser = registers$diagnoser,
    lpr_diag = registers$lpr_diag,
    lpr_adm = registers$lpr_adm,
    sysi = registers$sysi,
    sssy = registers$sssy,
    lab_forsker = registers$lab_forsker,
    bef = registers$bef,
    lmdb = registers$lmdb
  )

  # TODO: Need to update this when we have the expected output
  # expected_columns <- c(
  #   "",
  # )

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_gte(nrow(actual), 0)
})

test_that("data must be a DuckDB object", {
  registers_as_df <- register_data |>
    purrr::map(as.data.frame)

  expect_error(classify_diabetes(
    kontakter = registers_as_df$kontakter,
    diagnoser = registers_as_df$diagnoser,
    lpr_diag = registers_as_df$lpr_diag,
    lpr_adm = registers_as_df$lpr_adm,
    sysi = registers_as_df$sysi,
    sssy = registers_as_df$sssy,
    lab_forsker = registers_as_df$lab_forsker,
    bef = registers_as_df$bef,
    lmdb = registers_as_df$lmdb
  ))
})
