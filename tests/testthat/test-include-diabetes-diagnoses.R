register_data <- simulate_registers(c(
  "lpr_diag",
  "lpr_adm",
  "diagnoser",
  "kontakter"
))

lpr2 <- prepare_lpr2(
  lpr_adm = register_data$lpr_adm,
  lpr_diag = register_data$lpr_diag
)

lpr3 <- prepare_lpr3(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser
)


test_that("creates a data.frame output", {
  actual <- include_diabetes_diagnoses(
    lpr2 = lpr2,
    lpr3 = lpr3
  )

  expect_contains(class(actual), "data.frame")
})
