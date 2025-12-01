test_that("expected cases are classified correctly", {
  edge_case_data <- edge_cases() |>
    purrr::map(duckplyr::as_duckdb_tibble) |>
    purrr::map(duckplyr::as_tbl)

  actual <- classify_diabetes(
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
    dplyr::filter(grepl("\\d{2}_", .data$pnr)) |>
    dplyr::arrange(pnr) |>
    dplyr::collect()

  expected <- edge_case_data$classified |>
    dplyr::collect()

  expect_identical(actual, expected)
})
