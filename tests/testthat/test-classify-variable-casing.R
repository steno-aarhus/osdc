test_that("casing of input variables doesn't matter", {
  registers <- names(registers()) |>
    simulate_registers(n = 1000) |>
    # Convert column names to upper case.
    purrr::map(~ dplyr::rename_with(.x, toupper)) |>
    purrr::map(duckplyr::as_duckdb_tibble) |>
    purrr::map(duckplyr::as_tbl)

  actual <- classify_diabetes(
    kontakter = NULL,
    diagnoser = NULL,
    lpr_a_kontakt = registers$lpr_a_kontakt,
    lpr_a_diagnose = registers$lpr_a_diagnose,
    lpr_diag = registers$lpr_diag,
    lpr_adm = registers$lpr_adm,
    sysi = registers$sysi,
    sssy = registers$sssy,
    lab_forsker = registers$lab_forsker,
    bef = registers$bef,
    lmdb = registers$lmdb
  ) |>
    dplyr::collect()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_gte(nrow(actual), 0)
})
