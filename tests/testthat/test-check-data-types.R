test_that("passes when non-required cols appear in the data", {
  data <- tibble::tibble(
    unknown_col = "test"
  )
  expect_true(check_data_types(data, "kontakter"))
})

test_that("passes when cols have the expected data types (register with multiple expected data types)", {
  # `lab_forsker` has a column (`samplingdate`) that has multiple expected data types.
  kontakter <- tibble::tibble(
    patient_cpr = c("1", "2"),
    samplingdate = c("2020-01-01", "2020-01-02"),
    analysiscode = c("A", "B"),
    value = c(1, 2)
  )
  expect_true(check_data_types(kontakter, "lab_forsker"))
})


test_that("passes when cols have the expected data types (register with only one expected data type per column)", {
  # `diagnoser` only has columns with one expected data type.
  diagnoser <- tibble::tibble(
    dw_ek_kontakt = c("1", "2"),
    diagnosekode = c("DM13", "DM13"),
    diagnosetype = c("A", "B"),
    senere_afkraeftet = c("Ja", "Nej")
  )
  expect_true(check_data_types(diagnoser, "diagnoser"))
})

test_that("fails when cols are unexpected data types", {
  data <- tibble::tibble(
    cpr = c(1, 2),
  )
  expect_error(check_data_types(data, "kontakter"))
})

test_that("fails with unknown or incorrect register", {
  unknown_register <- tibble::tibble(
    cpr = c("1", "2")
  )
  expect_error(check_data_types(unknown_register, "unknown_register"))
})
