test_that("get_majority_of_t1d() works correctly", {
  # Two cases: Endocrinology diagnoses present: compare endo counts
  expect_true(
    get_majority_of_t1d(
      n_t1d_endocrinology = 3,
      n_t2d_endocrinology = 1,
      n_t1d_medical = 0,
      n_t2d_medical = 5
    )
  )

  expect_false(
    get_majority_of_t1d(
      n_t1d_endocrinology = 1,
      n_t2d_endocrinology = 2,
      n_t1d_medical = 5,
      n_t2d_medical = 0
    )
  )

  # Two cases: No endocrinology diagnoses: compare medical counts
  expect_true(
    get_majority_of_t1d(
      n_t1d_endocrinology = 0,
      n_t2d_endocrinology = 0,
      n_t1d_medical = 4,
      n_t2d_medical = 2
    )
  )

  expect_false(
    get_majority_of_t1d(
      n_t1d_endocrinology = 0,
      n_t2d_endocrinology = 0,
      n_t1d_medical = 1,
      n_t2d_medical = 3
    )
  )

  # Edge case: No type-specific diagnoses at all: should return FALSE
  expect_false(
    get_majority_of_t1d(
      n_t1d_endocrinology = 0,
      n_t2d_endocrinology = 0,
      n_t1d_medical = 0,
      n_t2d_medical = 0
    )
  )
})
