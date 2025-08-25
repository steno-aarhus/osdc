# Moved from `exclude-potential-pcos` -------------------------------------

# bef <- tibble::tribble(
#   ~koen, ~pnr, ~foed_dato,
#   # Men (as defined by PNR)
#   1, 1000000001, "1980-01-01",
#   # Women (as defined by PNR)
#   2, 2000000000, "1980-01-01",
#   # No GLD purchases (excluded)
#   1, 3000000001, "1980-01-01",
#   2, 4000000000, "1980-01-01",
# ) |>
#   dplyr::mutate(
#     pnr = as.character(pnr),
#     foed_dato = lubridate::as_date(foed_dato)
#   )

# gld_purchases <- tibble::tribble(
#   ~pnr, ~date, ~atc, ~has_gld_purchases, ~indication_code,
#   # Men (as defined by PNR)
#   ## ATC matches criteria
#   ### Age at purchase matches criteria (< 40)
#   1000000001, "2010-02-02", "A10BA02", TRUE, "324314324",
#   1000000001, "2010-02-02", "A10BA02", TRUE, "0000092", # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   1000000001, "2020-02-02", "A10BA02", TRUE, "324314324",
#   1000000001, "2020-02-02", "A10BA02", TRUE, "0000781", # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   1000000001, "2025-02-02", "A10BA02", TRUE, "324314324",
#   1000000001, "2025-02-02", "A10BA02", TRUE, "0000276", # indication_code matches
#   ## ATC doesn't match criteria
#   ### Age at purchase matches criteria (< 40)
#   1000000001, "2010-02-02", "A10", TRUE, "324314324",
#   1000000001, "2010-02-02", "A10", TRUE, "0000092", # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   1000000001, "2020-02-02", "A10", TRUE, "324314324",
#   1000000001, "2020-02-02", "A10", TRUE, "0000781", # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   1000000001, "2025-02-02", "A10", TRUE, "324314324",
#   1000000001, "2025-02-02", "A10", TRUE, "0000276", # indication_code matches

#   # Women (as defined by PNR)
#   ## ATC matches criteria
#   ### Age at purchase matches criteria (< 40)
#   2000000000, "2010-02-02", "A10BA02", TRUE, "324314324", # excluded
#   2000000000, "2010-02-02", "A10BA02", TRUE, "0000092", # indication_code matches, excluded
#   ### Age at purchase doesn't match (= 40)
#   2000000000, "2020-02-02", "A10BA02", TRUE, "324314324",
#   2000000000, "2020-02-02", "A10BA02", TRUE, "0000781", # indication_code matches, excluded
#   ### Age at purchase doesn't match (> 40)
#   2000000000, "2025-02-02", "A10BA02", TRUE, "324314324",
#   2000000000, "2025-02-02", "A10BA02", TRUE, "0000276", # indication_code matches, excluded
#   ## ATC doesn't match criteria
#   ### Age at purchase matches criteria (< 40)
#   2000000000, "2010-02-02", "A10", TRUE, "324314324",
#   2000000000, "2010-02-02", "A10", TRUE, "0000092", # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   2000000000, "2020-02-02", "A10", TRUE, "324314324",
#   2000000000, "2020-02-02", "A10", TRUE, "0000781", # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   2000000000, "2025-02-02", "A10", TRUE, "324314324",
#   2000000000, "2025-02-02", "A10", TRUE, "0000276", # indication_code matches
#   # Not in BEF (excluded)
#   5000000000, "2010-01-01", "A10", TRUE, "0000276",
# ) |>
#   dplyr::mutate(pnr = as.character(pnr), date = lubridate::as_date(date))

# expected <- tibble::tribble(
#   ~pnr, ~date, ~atc, ~has_gld_purchases, ~indication_code, ~no_pcos,
#   # Men (as defined by PNR)
#   ## ATC matches criteria
#   ### Age at purchase matches criteria (< 40)
#   1000000001, "2010-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   1000000001, "2010-02-02", "A10BA02", TRUE, "0000092", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   1000000001, "2020-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   1000000001, "2020-02-02", "A10BA02", TRUE, "0000781", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   1000000001, "2025-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   1000000001, "2025-02-02", "A10BA02", TRUE, "0000276", TRUE, # indication_code matches
#   ## ATC doesn't match criteria
#   ### Age at purchase matches criteria (< 40)
#   1000000001, "2010-02-02", "A10", TRUE, "324314324", TRUE,
#   1000000001, "2010-02-02", "A10", TRUE, "0000092", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   1000000001, "2020-02-02", "A10", TRUE, "324314324", TRUE,
#   1000000001, "2020-02-02", "A10", TRUE, "0000781", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   1000000001, "2025-02-02", "A10", TRUE, "324314324", TRUE,
#   1000000001, "2025-02-02", "A10", TRUE, "0000276", TRUE, # indication_code matches

#   # Women (as defined by PNR)
#   ## ATC matches criteria
#   ### Age at purchase matches criteria (< 40)
#   ### Age at purchase doesn't match (= 40)
#   2000000000, "2020-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   ### Age at purchase doesn't match (> 40)
#   2000000000, "2025-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   ## ATC doesn't match criteria
#   ### Age at purchase matches criteria (< 40)
#   2000000000, "2010-02-02", "A10", TRUE, "324314324", TRUE,
#   2000000000, "2010-02-02", "A10", TRUE, "0000092", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (= 40)
#   2000000000, "2020-02-02", "A10", TRUE, "324314324", TRUE,
#   2000000000, "2020-02-02", "A10", TRUE, "0000781", TRUE, # indication_code matches
#   ### Age at purchase doesn't match (> 40)
#   2000000000, "2025-02-02", "A10", TRUE, "324314324", TRUE,
#   2000000000, "2025-02-02", "A10", TRUE, "0000276", TRUE, # indication_code matches
# ) |>
#   dplyr::mutate(pnr = as.character(pnr), date = lubridate::as_date(date))

# Moved from `exclude-pregnancy` ------------------------------------------

# excluded_pcos <- tibble::tribble(
#   ~pnr, ~date, ~atc, ~has_gld_purchases, ~indication_code, ~no_pcos,
#   # More than 40 weeks before pregnancy event (keep).
#   1, "2000-01-01", "A10BA02", TRUE, "324314324", TRUE,
#   1, "2019-01-01", "A10BA02", TRUE, "324314324", TRUE,
#   # Exactly 40 weeks before pregnancy event (drop).
#   1, "2009-04-28", "A10BA02", TRUE, "324314324", TRUE,
#   1, "2019-04-28", "A10BA02", TRUE, "324314324", TRUE,
#   # Within pregnancy interval (drop).
#   1, "2010-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   1, "2020-02-02", "A10BA02", TRUE, "324314324", TRUE,
#   # Exactly 12 weeks after pregnancy event (drop).
#   1, "2010-04-27", "A10BA02", TRUE, "324314324", TRUE,
#   1, "2020-04-26", "A10BA02", TRUE, "324314324", TRUE, # Not the date same as row above bc 2020 is a gap year.
#   # More than 12 weeks after pregnancy event (keep).
#   1, "2015-01-01", "A10BA02", TRUE, "324314324", TRUE,
#   1, "2025-01-01", "A10BA02", TRUE, "324314324", TRUE,
#   # No pregnancy event (keep).
#   2, "2010-02-02", "A10BA02", TRUE, "324314324", TRUE,
# ) |>
#   dplyr::mutate(date = lubridate::as_date(date))
#
# included_hba1c <- tibble::tribble(
#   ~pnr, ~date,
#   # More than 40 weeks before pregnancy event (keep).
#   1, "2000-01-01",
#   1, "2000-01-02",
#   # Exactly 40 weeks before pregnancy event (drop).
#   1, "2009-04-28",
#   # Within pregnancy interval (drop).
#   1, "2010-02-02",
#   # Exactly 12 weeks after pregnancy event (drop).
#   1, "2010-04-27",
#   # More than 12 weeks after pregnancy event (keep).
#   1, "2015-01-02",
#   # No pregnancy event (keep).
#   3, "2010-02-02"
# ) |>
#   dplyr::mutate(date = lubridate::as_date(date))
#
# pregnancy_dates <- tibble::tribble(
#   ~pnr, ~pregnancy_event_date, ~has_pregnancy_event,
#   # Two pregnancy events for the same pnr to ensure that all events within both
#   # pregnancy intervals are excluded.
#   1, "2010-02-02", TRUE,
#   1, "2020-02-02", TRUE,
#   # Pregnancy event for pnr not in gld_purchases and included_hba1c (drop).
#   4, "2010-01-01", TRUE,
# ) |>
#   dplyr::mutate(pregnancy_event_date = lubridate::as_date(pregnancy_event_date))
#
# expected <- tibble::tribble(
#   ~pnr, ~date, ~has_gld_purchases, ~has_elevated_hba1c, ~no_pregnancy,
#   # From excluded_pcos.
#   1, "2000-01-01", TRUE, NA, TRUE, # Same pnr and date as row from hba1c, both kept.
#   1, "2019-01-01", TRUE, NA, TRUE,
#   1, "2015-01-01", TRUE, NA, TRUE,
#   1, "2025-01-01", TRUE, NA, TRUE,
#   2, "2010-02-02", TRUE, NA, TRUE,
#   # From included_hba1c.
#   1, "2000-01-01", NA, NA, TRUE, TRUE, # Same pnr and date as row from excluded_pcos, both kept.
#   1, "2000-01-02", NA, NA, TRUE, TRUE,
#   1, "2015-01-02", NA, NA, TRUE, TRUE,
#   3, "2010-02-02", NA, NA, TRUE, TRUE
# ) |>
#   dplyr::mutate(date = lubridate::as_date(date))

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
