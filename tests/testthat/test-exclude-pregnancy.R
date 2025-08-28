register_data <- simulate_registers(
  c(
    "lpr_adm",
    "lpr_diag",
    "kontakter",
    "diagnoser",
    "lmdb",
    "bef",
    "lab_forsker"
  ),
  n = 1000
)
lpr2 <- prepare_lpr2(
  lpr_adm = register_data$lpr_adm,
  lpr_diag = register_data$lpr_diag
)
lpr3 <- prepare_lpr3(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser
)

no_pcos <- register_data$lmdb |>
  include_gld_purchases() |>
  add_insulin_purchases_cols() |>
  exclude_potential_pcos(register_data$bef)

preg_dates <- get_pregnancy_dates(lpr2, lpr3)

hba1c <- include_hba1c(register_data$lab_forsker)

test_that("pregnancy events are excluded as expected", {
  actual <- exclude_pregnancy(
    excluded_pcos = no_pcos,
    pregnancy_dates = preg_dates,
    included_hba1c = hba1c
  )
  expect_contains(class(actual), "data.frame")
})
