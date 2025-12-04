sim_data <- registers() |>
  names() |>
  simulate_registers(n = 10000)
cases <- edge_cases()
nc <- non_cases()

join_registers <- function(name) {
  dplyr::bind_rows(
    cases[[name]],
    sim_data[[name]],
    nc[[name]]
  )
}

cases_vs_nc <- sim_data |>
  names() |>
  purrr::map(\(name) {
    list(join_registers(name)) |>
      rlang::set_names(name)
  }) |>
  purrr::flatten() |>
  purrr::map(duckplyr::as_duckdb_tibble) |>
  purrr::map(duckplyr::as_tbl)

actual <- classify_diabetes(
  kontakter = cases_vs_nc$kontakter,
  diagnoser = cases_vs_nc$diagnoser,
  lpr_diag = cases_vs_nc$lpr_diag,
  lpr_adm = cases_vs_nc$lpr_adm,
  sysi = cases_vs_nc$sysi,
  sssy = cases_vs_nc$sssy,
  lab_forsker = cases_vs_nc$lab_forsker,
  bef = cases_vs_nc$bef,
  lmdb = cases_vs_nc$lmdb
) |>
  dplyr::collect()

test_that("expected cases are classified correctly", {
  expected <- cases$classified
  actual_cases <- actual |>
    dplyr::filter(grepl("\\d{2}_", .data$pnr)) |>
    dplyr::arrange(pnr)
  expect_identical(actual_cases, expected)
})

test_that("expected non-cases are not classified", {
  nc_pnrs <- names(non_cases_metadata())
  # No PNRs from non-cases have been classified.
  expected_pnrs <- actual |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expect_identical(expected_pnrs, character(0))
})
