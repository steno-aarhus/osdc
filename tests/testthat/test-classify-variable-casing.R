test_that("casing of input variables doesn't matter", {
  registers <- names(registers()) |>
    simulate_registers(n = 1000) |>
    # Convert column names to upper case.
    purrr::map(~ dplyr::rename_with(.x, toupper))

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
  ) |>
    dplyr::collect()

  actual_rows <- actual |>
    dplyr::count() |>
    dplyr::pull(n) |>
    as.integer()

  expect_gte(nrow(actual), 0)
})
