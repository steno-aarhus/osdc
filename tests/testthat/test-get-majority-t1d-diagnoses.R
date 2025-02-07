# Test: Majority is determined from endocrinology when counts are available
test_that("Error in determining majority from endocrinology when counts are available", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 3, n_t2d_endocrinology = 2,
                                  n_t1d_medical = 5, n_t2d_medical = 10),
    TRUE
  )

  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 1, n_t2d_endocrinology = 4,
                                  n_t1d_medical = 10, n_t2d_medical = 3),
    FALSE
  )
})

# Test: Majority is determined from medical departments when endocrinology is unavailable
test_that("Error in determining majority from medical departments when endocrinology is unavailable", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 0, n_t2d_endocrinology = 0,
                                  n_t1d_medical = 8, n_t2d_medical = 4),
    TRUE
  )

  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 0, n_t2d_endocrinology = 0,
                                  n_t1d_medical = 2, n_t2d_medical = 6),
    FALSE
  )
})

# Test: Returns FALSE when number of diagnoses are equal
test_that("Error when counts are equal between type 1 and type 2 diagnoses", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 1, n_t2d_endocrinology = 1,
                                  n_t1d_medical = 10, n_t2d_medical = 3),
    FALSE
  )

  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 0, n_t2d_endocrinology = 0,
                                  n_t1d_medical = 1, n_t2d_medical = 1),
    FALSE
  )
})

# Test: All counts are zero (edge case)
test_that("Error when all counts are zero", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 0, n_t2d_endocrinology = 0,
                                  n_t1d_medical = 0, n_t2d_medical = 0),
    FALSE
  )
})

# Test: NA handling
test_that("Error when NA values are present in endocrinology or medical counts", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = NA, n_t2d_endocrinology = NA,
                                  n_t1d_medical = 3, n_t2d_medical = 1),
    TRUE
  )

  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 2, n_t2d_endocrinology = 3,
                                  n_t1d_medical = NA, n_t2d_medical = NA),
    FALSE
  )
})

# Test: Mixed counts with NA values
test_that("Error when mixed NA values are present in counts", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = 1, n_t2d_endocrinology = NA,
                                  n_t1d_medical = NA, n_t2d_medical = 1),
    TRUE
  )
})

# Test: Non-positive counts (extreme case, can't see this happening)
test_that("Error when non-positive counts are provided", {
  expect_equal(
    get_majority_of_t1d_diagnoses(n_t1d_endocrinology = -1, n_t2d_endocrinology = -2,
                                  n_t1d_medical = 0, n_t2d_medical = 0),
    FALSE
  )
})
