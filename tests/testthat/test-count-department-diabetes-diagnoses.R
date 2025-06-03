# Define test input data
test_df <- tibble::tibble(
  pnr = c(rep("000000000000000001", 4), rep("000000000000000002", 3),
          rep("000000000000000003", 3), "000000000000000004", "000000000000000005"),
  is_t1d =      c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE),
  is_t2d =      c(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  is_primary =  c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, TRUE, TRUE),
  is_endo_department =  c(TRUE, TRUE, TRUE, FALSE,
                          TRUE, FALSE, FALSE,
                          FALSE, TRUE, NA,
                          FALSE, NA)
)

# Run function once outside of individual tests
output_df <- count_primary_diagnoses_by_department(test_df)

# Run tests

test_that("Error: Output has incorrect column names and/or number of columns", {
  expect_named(output_df, c("pnr", "is_t1d", "is_t2d", "is_primary", "is_endo_department", "n_t1d_endocrinology", "n_t2d_endocrinology", "n_t1d_medical", "n_t2d_medical"))
  expect_equal(ncol(output_df), 9)
})

# === Row-specific content tests ===
test_that("Error: pnr 000000000000000001 has incorrect counts: expected 2 T1D from endo & 1 T2D from endo", {
  row <- output_df |> dplyr::filter(pnr == "000000000000000001") |> dplyr::slice_head(n = 1) # Test only the first row, since all rows within each pnr are identical

  expect_equal(row$n_t1d_endocrinology, 2) # 2 T1D primary in endo
  expect_equal(row$n_t2d_endocrinology, 1) # 1 T2D primary in endo
  expect_equal(row$n_t1d_medical, 0) # none in 'other medical'
  expect_equal(row$n_t2d_medical, 0) # one, but not primary
})

test_that("Error: pnr 000000000000000002 has incorrect counts: expected 1 T1D from endo & 1 T2D from other medical", {
  row <- output_df |> dplyr::filter(pnr == "000000000000000002") |> dplyr::slice_head(n = 1)

  expect_equal(row$n_t1d_endocrinology, 1)
  expect_equal(row$n_t2d_endocrinology, 0)
  expect_equal(row$n_t1d_medical, 0)
  expect_equal(row$n_t2d_medical, 1)
})

test_that("Error: pnr 000000000000000003 has incorrect counts: expected 1 T2D from other medical", {
  row <- output_df |> dplyr::filter(pnr == "000000000000000003") |> dplyr::slice_head(n = 1)

  expect_equal(row$n_t1d_endocrinology, 0)
  expect_equal(row$n_t2d_endocrinology, 0)  # Has only secondary diagnoses from endo departments
  expect_equal(row$n_t1d_medical, 0)
  expect_equal(row$n_t2d_medical, 1)
})

test_that("Error: pnr 000000000000000004 has incorrect counts: expected 1 T1D from other medical", {
  row <- output_df |> dplyr::filter(pnr == "000000000000000004") |> dplyr::slice_head(n = 1)

  expect_equal(row$n_t1d_endocrinology, 0)
  expect_equal(row$n_t2d_endocrinology, 0)
  expect_equal(row$n_t1d_medical, 1)
  expect_equal(row$n_t2d_medical, 0)
})

test_that("Error: pnr 000000000000000005 has incorrect counts: expected zero type-specific primary diagnoses", {
  row <- output_df |> dplyr::filter(pnr == "000000000000000005") |> dplyr::slice_head(n = 1)

  expect_equal(row$n_t1d_endocrinology, 0)
  expect_equal(row$n_t2d_endocrinology, 0)
  expect_equal(row$n_t1d_medical, 0)
  expect_equal(row$n_t2d_medical, 0)
})
