test_that("casing of input variables doesn't matter", {
  registers <- names(registers()) |>
    simulate_registers(n = 1000) |>
    # Convert column names to upper case.
    purrr::map(~ dplyr::rename_with(.x, toupper)) |>
    purrr::map(duckplyr::as_duckdb_tibble) |>
    purrr::map(duckplyr::as_tbl)

  lpr <- list(
    prepare_lpr2(registers$lpr_adm, registers$lpr_diag),
    prepare_lpr3f(registers$lpr3f_kontakter, registers$lpr3f_diagnoser),
    prepare_lpr3a(registers$lpr3a_kontakt, registers$lpr3a_diagnose)
  ) |>
    join_registers()

  hsr <- list(registers$sssy, registers$sysi) |> join_registers()

  actual <- classify_diabetes(
    lpr = lpr,
    hsr = hsr,
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
