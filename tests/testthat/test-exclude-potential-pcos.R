bef <- simulate_registers("bef", 1000)[[1]] |>
  dplyr::add_row(
    koen = 2,
    foed_dato = "20000101"
  )
gld_purchases <- simulate_registers("lmdb", 1000)[[1]] |>
  include_gld_purchases() |>
  dplyr::add_row(
    date = "20200101",
    atc = "A10BA02",
    # Not the indication code
    indication_code = "0000091",
  )

test_that("bef needs expected variables", {
  bef <- bef[-2]
  expect_error(exclude_potential_pcos(gld_purchases, bef))
})

test_that("at least there are some (random) 'cases'", {
  actual <- exclude_potential_pcos(gld_purchases, bef)
  # Should be at least one row less after exclusion
  expect_true(nrow(actual) <= nrow(gld_purchases) - 1)
})
