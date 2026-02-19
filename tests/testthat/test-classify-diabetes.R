sim_data <- registers() |>
  names() |>
  simulate_registers(n = 10000)
cases <- edge_cases()
nc <- non_cases()

join_registers <- function(name) {
  combined_df <- dplyr::bind_rows(
    cases[[name]],
    sim_data[[name]],
    nc[[name]]
  )

  # Bind_rows reverses the order of attributes, which upsets DuckDB
  # Solution/work-around: Reconstruct POSIXct columns from scratch and
  # enforce canonical attribute order
  combined_df |>
    dplyr::mutate(across(where(lubridate::is.POSIXct), \(x) {
      # Strip to raw seconds (numeric)
      raw_vals <- as.numeric(x)

      # Rebuild strictly as UTC POSIXct
      # This forces 'class' to be set first, then 'tzone'
      structure(raw_vals, class = c("POSIXct", "POSIXt"), tzone = "UTC")
    }))
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

# Test with only LPR3 data from LPR A
actual_only_lpr_a <- classify_diabetes(
  diagnoser = NULL,
  kontakter = NULL,
  lpr_a_diagnose = cases_vs_nc$lpr_a_diagnose,
  lpr_a_kontakt = cases_vs_nc$lpr_a_kontakt,
  lpr_diag = cases_vs_nc$lpr_diag,
  lpr_adm = cases_vs_nc$lpr_adm,
  sysi = cases_vs_nc$sysi,
  sssy = cases_vs_nc$sssy,
  lab_forsker = cases_vs_nc$lab_forsker,
  bef = cases_vs_nc$bef,
  lmdb = cases_vs_nc$lmdb
) |>
  dplyr::collect()

# Test with only LPR3 data from LPR F
actual_only_lpr_f <- classify_diabetes(
  diagnoser = cases_vs_nc$diagnoser,
  kontakter = cases_vs_nc$kontakter,
  lpr_a_diagnose = NULL,
  lpr_a_kontakt = NULL,
  lpr_diag = cases_vs_nc$lpr_diag,
  lpr_adm = cases_vs_nc$lpr_adm,
  sysi = cases_vs_nc$sysi,
  sssy = cases_vs_nc$sssy,
  lab_forsker = cases_vs_nc$lab_forsker,
  bef = cases_vs_nc$bef,
  lmdb = cases_vs_nc$lmdb
) |>
  dplyr::collect()

# Test with a mix of LPR3 data from LPR A and F

lpr_f_part <- cases_vs_nc$kontakter |>
  dplyr::filter(dplyr::row_number() %in% 1:10)
lpr_a_part <- cases_vs_nc$lpr_a_kontakt |>
  dplyr::filter(!dplyr::row_number() %in% 1:10)

actual_mix_lpr3 <- classify_diabetes(
  diagnoser = cases_vs_nc$diagnoser,
  kontakter = lpr_f_part,
  lpr_a_diagnose = cases_vs_nc$lpr_a_diagnose,
  lpr_a_kontakt = lpr_a_part,
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
  actual_cases_lpr_a <- actual_only_lpr_f |>
    dplyr::filter(grepl("\\d{2}_", .data$pnr)) |>
    dplyr::arrange(pnr)

  expect_identical(actual_cases_lpr_a, expected)

  actual_cases_lpr_f <- actual_only_lpr_a |>
    dplyr::filter(grepl("\\d{2}_", .data$pnr)) |>
    dplyr::arrange(pnr)

  expect_identical(actual_cases_lpr_f, expected)

  actual_cases_mix_lpr3 <- actual_mix_lpr3 |>
    dplyr::filter(grepl("\\d{2}_", .data$pnr)) |>
    dplyr::arrange(pnr)

  expect_identical(actual_cases_mix_lpr3, expected)
})

test_that("expected non-cases are not classified", {
  nc_pnrs <- names(non_cases_metadata())
  # No PNRs from non-cases have been classified.
  expected_pnrs_only_lpr_f <- actual_only_lpr_f |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expected_pnrs_only_lpr_a <- actual_only_lpr_a |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expected_pnrs_mix_lpr3 <- actual_mix_lpr3 |>
    dplyr::filter(.data$pnr %in% nc_pnrs) |>
    dplyr::pull(.data$pnr) |>
    unique()

  expect_identical(expected_pnrs_only_lpr_f, character(0))
  expect_identical(expected_pnrs_only_lpr_a, character(0))
  expect_identical(expected_pnrs_mix_lpr3, character(0))
})
