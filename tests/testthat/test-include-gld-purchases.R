lmdb <- simulate_registers("lmdb", 1000)[[1]]

test_that("dataset needs expected variables", {
  actual <- lmdb[-2]
  expect_error(include_gld_purchases(actual))
})

test_that("there's at least some 'cases' in the simulated data", {
  actual <- include_gld_purchases(lmdb)
  expect_equal(nrow(dplyr::count(actual, has_two_thirds_insulin)), 2)
  expect_equal(nrow(dplyr::count(actual, has_only_insulin_purchases)), 2)
  expect_equal(
    nrow(dplyr::count(actual, has_insulin_purchases_within_180_days)),
    2
  )
})
