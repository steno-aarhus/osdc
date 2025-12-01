test_that("expected non-cases are not classified", {
  nc <- non_cases()

  nc <- nc |>
    # To try to fix a CRAN check error because of a DuckDB connection
    # issue.
    rlang::set_names(paste0("nc_", names(nc))) |>
    purrr::map(duckplyr::as_duckdb_tibble) |>
    purrr::map(duckplyr::as_tbl)

  actual <- classify_diabetes(
    kontakter = nc$nc_kontakter,
    diagnoser = nc$nc_diagnoser,
    lpr_diag = nc$nc_lpr_diag,
    lpr_adm = nc$nc_lpr_adm,
    sysi = nc$nc_sysi,
    sssy = nc$nc_sssy,
    lab_forsker = nc$nc_lab_forsker,
    bef = nc$nc_bef,
    lmdb = nc$nc_lmdb
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
