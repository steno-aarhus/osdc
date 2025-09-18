lmdb <- simulate_registers("lmdb", 1000)[[1]]

test_that("creates a data.frame output", {
  actual <- keep_gld_purchases(lmdb)
  expect_contains(class(actual), "data.frame")
})
