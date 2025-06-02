test_that("only available registers are generated", {
  expect_error(simulate_registers("fake"))
  # Error even when one register is real.
  expect_error(simulate_registers(c("fake", "bef")))
})

test_that("one register can be simulated", {
  # Only one register
  fake_register <- simulate_registers("bef")
  expect_type(fake_register, "list")
  expect_contains(class(fake_register[[1]]), "tbl_df")
  expect_length(fake_register, 1)

  # Different length
  expect_equal(nrow(simulate_registers("bef", 100)[[1]]), 100)
})

test_that("two registers can be simulated", {
  simulated_registers <- simulate_registers(c("bef", "lmdb"))
  expect_type(simulated_registers, "list")
  expect_contains(class(simulated_registers[[1]]), "tbl_df")
  expect_contains(class(simulated_registers[[2]]), "tbl_df")
  expect_length(simulated_registers, 2)

  # Different length
  small_simulated_registers <- simulate_registers(c("bef", "lmdb"), 100)
  expect_equal(nrow(small_simulated_registers[[1]]), 100)
  expect_equal(nrow(small_simulated_registers[[2]]), 100)
})

test_that("padded integers for given length and n are always the same", {
  actual <- create_padded_integer(2, 2)
  expected <- c("45", "57")
  expect_equal(actual, expected)

  actual <- create_padded_integer(3, 2)
  expected <- c("47", "50", "50")
  expect_equal(actual, expected)

  actual <- create_padded_integer(2, 3)
  expected <- c("469", "937")
  expect_equal(actual, expected)
})
