lmdb <- simulate_registers("lmdb", 1000)[[1]]

test_that("dataset needs expected variables", {
  actual <- lmdb[-2]
  expect_error(include_gld_purchases(actual))
})

test_that("creates a data.frame output", {
  actual <- include_gld_purchases(lmdb)
  expect_contains(class(actual), "data.frame")
})
