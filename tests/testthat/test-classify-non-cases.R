test_that("expected non-cases are not classified", {
  set.seed(5035924)
  nc <- non_cases() |>
    purrr::map(duckplyr::as_duckdb_tibble) |>
    purrr::map(duckplyr::as_tbl)

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
  ) |>
    dplyr::filter(grepl("^.._", .data$pnr)) |>
    dplyr::collect()

  nc_pnrs <- names(non_cases_metadata())
  # No PNRs from non-cases have been classified.
  expected_pnrs <- actual |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expect_identical(expected_pnrs, character(0))
})
