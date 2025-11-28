test_that("data must be a DuckDB object", {
  as_df <- names(registers()) |>
    simulate_registers(n = 1000) |>
    purrr::map(dplyr::collect)

  expect_error(classify_diabetes(
    kontakter = as_df$kontakter,
    diagnoser = as_df$diagnoser,
    lpr_diag = as_df$lpr_diag,
    lpr_adm = as_df$lpr_adm,
    sysi = as_df$sysi,
    sssy = as_df$sssy,
    lab_forsker = as_df$lab_forsker,
    bef = as_df$bef,
    lmdb = as_df$lmdb
  ))
})
