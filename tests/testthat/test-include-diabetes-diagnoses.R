register_data <- simulate_registers(c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"), n = 1000)

lpr2 <- prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag) |>
  # At least one true case
  dplyr::add_row(
    pnr = "99",
    date = as.Date("2020-01-01"),
    is_t1d_code = TRUE,
    is_t2d_code = FALSE,
    is_primary_dx = TRUE,
    is_medical_dept = FALSE,
    is_diabetes_code = TRUE,
    is_endocrinology_dept = TRUE
  )
lpr3 <- prepare_lpr3(register_data$kontakter, register_data$diagnoser)

test_that("at least one 'case' is classified", {
  actual <- include_diabetes_diagnoses(
    lpr2 = lpr2,
    lpr3 = lpr3
  )

  expect_equal(nrow(dplyr::count(actual, has_majority_t1d_diagnosis)), 2)
})
