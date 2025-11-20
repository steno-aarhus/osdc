library(tibble)

bef_complete <- tibble::tibble(pnr = "1", koen = 1L, foed_dato = "1")

test_that("the correct abbreviation for the register is used", {
  # When incorrect register abbreviation is given
  expect_error(select_required_variables(bef_complete, "bef1"))
  # When correct abbreviation is given
  expect_identical(select_required_variables(bef_complete, "bef"), bef_complete)
})

test_that("the required variables are present in the dataset", {
  # Expected
  bef_incomplete <- tibble(pnr = "1", koen = 1L)

  # When all variables are the required variables
  expect_identical(select_required_variables(bef_complete, "bef"), bef_complete)

  expect_error(select_required_variables(bef_incomplete, "bef"))
})

test_that("when non-required cols appear in the data", {
  bef_complete_extra <- tibble(
    pnr = "1",
    koen = 1L,
    foed_dato = "1",
    something = 1
  )

  # When some of the variables are the required variables
  expect_identical(
    select_required_variables(bef_complete_extra, "bef"),
    bef_complete
  )
})

test_that("passes when cols have the expected data types (register with multiple expected data types)", {
  # `lab_forsker` has a column (`samplingdate`) that has multiple expected data types.
  kontakter <- tibble::tibble(
    patient_cpr = c("1", "2"),
    samplingdate = c("2020-01-01", "2020-01-02"),
    analysiscode = c("A", "B"),
    value = c(1, 2)
  )
  expect_identical(
    select_required_variables(kontakter, "lab_forsker"),
    kontakter
  )
})


test_that("passes when cols have the expected data types (register with only one expected data type per column)", {
  # `diagnoser` only has columns with one expected data type.
  diagnoser <- tibble::tibble(
    dw_ek_kontakt = c("1", "2"),
    diagnosekode = c("DM13", "DM13"),
    diagnosetype = c("A", "B"),
    senere_afkraeftet = c("Ja", "Nej")
  )
  expect_identical(select_required_variables(diagnoser, "diagnoser"), diagnoser)
})

test_that("fails when cols are unexpected data types", {
  data <- tibble::tibble(
    cpr = c(1, 2),
  )
  expect_error(select_required_variables(data, "kontakter"))
})

test_that("fails with unknown or incorrect register", {
  unknown_register <- tibble::tibble(
    cpr = c("1", "2")
  )
  expect_error(select_required_variables(unknown_register, "unknown_register"))
})

test_that("column names are converted to lower case", {
  bef_mixed_case <- tibble::tibble(
    PnR = "1",
    KoEn = 1L,
    FoEd_DaTo = "1"
  )

  expect_identical(
    select_required_variables(bef_mixed_case, "bef"),
    bef_complete
  )

  # And when converted to strict duckplyr
  bef_as_duckdb <- tibble::tibble(
    PnR = "1",
    KoEn = 1L,
    FoEd_DaTo = "1"
  ) |>
    duckplyr::as_duckdb_tibble(prudence = "stingy")

  expect_identical(
    select_required_variables(bef_as_duckdb, "bef") |>
      dplyr::collect(),
    bef_complete
  )
})
