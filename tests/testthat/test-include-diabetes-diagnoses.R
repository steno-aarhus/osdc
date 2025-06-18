test_input_from_lpr2 <- tibble::tribble(
    ~pnr,     ~date,        ~is_primary_dx, ~is_diabetes_code, ~is_t1d_code, ~is_t2d_code,
    ~is_pregnancy_code, ~is_endocrinology_dept, ~is_medical_dept,

    # 00001 - clear T1D case onset in 2015: lpr2: 2x T1D from endo (+ 1 from lpr3)
    "00001", "2015-01-01", TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE,
    "00001", "2015-02-01", TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE,

    # 00002 - T2D case onset in 2021: 2x non-DM from lpr2, mix of medical dept/other, mostly non-primary
    "00002", "2015-01-10", TRUE,  TRUE,  FALSE, TRUE,  FALSE, FALSE, TRUE,
    "00002", "2015-01-20", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
    "00002", "2015-01-30", FALSE, FALSE,  FALSE, FALSE, FALSE, FALSE, FALSE,

    # 00003 - Non-case: Only a pregnancy record in LPR2, nothing in LPR3
    "00003", "2015-06-15", TRUE, FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE,

    # 00004 - T2D case in 2021: Nothing from LPR2, mixed T1D/T2D diags from LPR3, but no primary T1D/T2D diags

    # 00005 - A non-included case (of likely T1D in LPR3, only non-DM in LPR2)
    "00005", "2015-01-01", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,

    # 00006 - Equal counts case: 1 x T2D + 1 x T1D from endo from LPR2, same from medical in LPR3
    "00006", "2015-02-01", TRUE, TRUE,  TRUE,  FALSE, FALSE, TRUE, FALSE,
    "00006", "2015-03-01", TRUE, TRUE,  FALSE, TRUE,  FALSE, TRUE,  FALSE
  ) |>
  dplyr::mutate(date = as.Date(date))

test_input_from_lpr3 <- tibble::tribble(
  ~pnr,     ~date,        ~is_primary_dx, ~is_diabetes_code, ~is_t1d_code, ~is_t2d_code,
  ~is_pregnancy_code, ~is_endocrinology_dept, ~is_medical_dept,

  # 00001 - clear T1D case: lpr2: 2x T1D from endo (+ 1 from lpr3)
  "00001", "2020-01-01", TRUE,  TRUE,  TRUE,  FALSE, FALSE, TRUE,  FALSE,

  # 00002 - T2D case onset in 2021: 2x non-DM from lpr2, mix of medical dept/other, mostly non-primary
  "00002", "2021-01-10", FALSE,  TRUE,  FALSE, TRUE,  FALSE, FALSE, TRUE,
  "00002", "2021-01-20", FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
  "00002", "2021-01-30", FALSE, TRUE,  FALSE, FALSE, FALSE, FALSE, FALSE,

  # 00003 - Non-case: Only a pregnancy record in LPR2, nothing in LPR3

  # 00004 - T2D case in 2021: Nothing from LPR2, mixed T1D/T2D diags from LPR3, but no primary T1D/T2D diags
  "00004", "2021-07-01", FALSE,  TRUE,  TRUE,  FALSE,  FALSE, FALSE, FALSE,
  "00004", "2021-07-15", FALSE, FALSE, FALSE,  FALSE,  FALSE, FALSE, TRUE,
  "00004", "2021-08-01", TRUE,  TRUE,  FALSE,  FALSE,  FALSE, FALSE, FALSE,
  "00004", "2021-08-15", TRUE,  TRUE,  FALSE,  FALSE,  FALSE, FALSE, TRUE,

  # 00005 - A non-included case (of likely T1D in LPR3, only non-DM diags in LPR2)
  "00005", "2022-01-01", TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,

  # 00006 - Equal counts case: 1 x T2D + 1 x T1D from endo from LPR2, same from medical in LPR3
  "00006", "2022-02-01", TRUE, TRUE,  TRUE,  FALSE, FALSE, FALSE, TRUE,
  "00006", "2022-03-01", TRUE, TRUE,  FALSE, TRUE,  FALSE, FALSE,  TRUE
) |>
  dplyr::mutate(date = as.Date(date))

expected_output <- tibble::tribble(
  ~pnr,    ~date,        ~n_t1d_endocrinology, ~n_t2d_endocrinology, ~n_t1d_medical, ~n_t2d_medical, ~has_lpr_diabetes_diagnosis,
  "00001", "2015-01-01",              3,                    0,               0,               0,              TRUE,
  "00001", "2015-02-01",              3,                    0,               0,               0,              TRUE,
  "00002", "2015-01-10",              0,                    0,               0,               1,              TRUE,
  "00002", "2021-01-10",              0,                    0,               0,               1,              TRUE,
  "00004", "2021-07-01",              0,                    0,               0,               0,              TRUE,
  "00004", "2021-08-01",              0,                    0,               0,               0,              TRUE,
  "00005", "2022-01-01",              1,                    0,               0,               0,              TRUE,
  "00006", "2015-02-01",              1,                    1,               1,               1,              TRUE,
  "00006", "2015-03-01",              1,                    1,               1,               1,              TRUE
) |>
  dplyr::mutate(date = as.Date(date))

# Test
test_that("Filtering and counting diabetes diagnoses", {
  actual_output <- include_diabetes_diagnoses(
    test_input_from_lpr2,
    test_input_from_lpr3
  )

  # Sorted stable comparison
  actual_output_sorted <- dplyr::arrange(actual_output, pnr, date)
  expected_output_sorted <- dplyr::arrange(expected_output, pnr, date)

  # Test
  expect_equal(actual_output_sorted, expected_output_sorted)
})
