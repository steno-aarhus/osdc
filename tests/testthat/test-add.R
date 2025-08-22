test_that("added column, but keep same number of rows", {
  register_data <- simulate_registers("lmdb", 1000)
  # Include GLD purchases
  gld_purchases <- include_gld_purchases(register_data$lmdb)
  # Add two-thirds insulin doses
  actual <- register_data$lmdb |>
    dplyr::select(pnr) |>
    add_two_thirds_and_only_insulin(gld_purchases = gld_purchases)

  expect_equal(nrow(actual), nrow(register_data$lmdb))
})
