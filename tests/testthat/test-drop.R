# drop_pcos()

bef <- simulate_registers("bef", 1000)[[1]] |>
  dplyr::add_row(
    koen = 2,
    foed_dato = "20000101"
  )
gld_purchases <- simulate_registers("lmdb", 1000)[[1]] |>
  keep_gld_purchases() |>
  add_insulin_purchases_cols() |>
  dplyr::add_row(
    date = "20200101",
    atc = "A10BA02",
    # Not an indication code from the logic, so it doesn't
    # trigger the `OR` part.
    indication_code = "0000091",
  )

test_that("bef needs expected variables", {
  bef <- bef[-2]
  expect_error(drop_pcos(gld_purchases, bef))
})

test_that("at least 1 'case' is removed using the simulated data", {
  actual <- drop_pcos(gld_purchases, bef)
  # Should be at least one row less after dropping rows.
  expect_true(nrow(actual) <= nrow(gld_purchases) - 1)
})

# drop_pregnancies() -----

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
  keep_gld_purchases() |>
  add_insulin_purchases_cols() |>
  drop_pcos(register_data$bef)

preg_dates <- keep_pregnancy_dates(lpr2, lpr3)

hba1c <- keep_hba1c(register_data$lab_forsker)

test_that("pregnancy events are dropped as expected", {
  actual <- drop_pregnancies(
    dropped_pcos = no_pcos,
    pregnancy_dates = preg_dates,
    included_hba1c = hba1c
  )
  expect_contains(class(actual), "data.frame")
})
