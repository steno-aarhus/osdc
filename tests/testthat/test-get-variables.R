test_that("internal `get_` variable helper functions give correct output", {

  # Should be character. Not sure if other tests are needed here.
  expect_type(get_register_abbrev(), "character")
  expect_type(get_required_variables("bef"), "character")

  # Only able to use register ids that are real.
  expect_error(get_required_variables("fake"))

  # Only allows a vector of one.
  expect_error(get_required_variables(c("bef", "atc")))
})
