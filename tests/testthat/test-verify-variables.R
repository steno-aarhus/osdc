library(tibble)

test_that("the correct abbreviation for the register is used", {
  bef_complete <- tibble(pnr = 1, koen = 1, foed_dato = 1)

  # Shouldn't
  expect_error(verify_required_variables(bef_complete, "bef1"))
  expect_true(verify_required_variables(bef_complete, "bef"))
})

test_that("the required variables are present in the dataset", {
  # Expected
  bef_complete <- tibble(pnr = 1, koen = 1, foed_dato = 1)
  bef_complete_extra <- tibble(pnr = 1, koen = 1, foed_dato = 1, something = 1)
  bef_incomplete <- tibble(pnr = 1, koen = 1)

  # When all variables are the required variables
  expect_true(verify_required_variables(bef_complete, "bef"))

  # When some of the variables are the required variables
  expect_true(verify_required_variables(bef_complete_extra, "bef"))

  # When it is a character output, it is a fail.
  expect_type(verify_required_variables(bef_incomplete, "bef"), "character")
})
