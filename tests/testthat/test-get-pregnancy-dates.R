lpr2 <- tibble::tribble(
  ~pnr, ~date, ~is_primary_diagnosis, ~is_diabetes_code, ~is_t1d_code, ~is_t2d_code, ~is_endocrinology_dept, ~is_medical_dept, ~is_pregnancy_code,
  # No pregnancy diagnosis (drop).
  1, "1990-01-01", TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  # Pregnancy diagnosis (keep).
  2, "1990-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  2, "2000-01-01", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, # Duplicate PNR, other date, keep both.
  3, "1990-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  3, "1990-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, # Duplicate PNR, same date, keep one.
) |>
  dplyr::mutate(
    date = lubridate::as_date(date)
  )


lpr3 <- tibble::tribble(
  ~pnr, ~date, ~is_primary_diagnosis, ~is_diabetes_code, ~is_t1d_code, ~is_t2d_code, ~is_endocrinology_dept, ~is_medical_dept, ~is_pregnancy_code,
  # No pregnancy diagnosis (drop).
  4, "2020-01-01", TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  # Pregnancy diagnosis (keep).
  5, "2020-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  5, "2009-01-01", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, # Duplicate PNR, other date, keep both.
  6, "2020-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  6, "2020-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, # Duplicate PNR, same date, keep one.
  2, "2020-01-01", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, # Duplicate PNR from LPR2, keep both.
) |>
  dplyr::mutate(
    date = lubridate::as_date(date)
  )

expected_pregnancy_dates <- tibble::tribble(
  ~pnr, ~pregnancy_event_date, ~has_pregnancy_event,
  # From LPR2.
  2, "1990-01-01", TRUE,
  2, "2000-01-01", TRUE,
  3, "1990-01-01", TRUE,
  # From LPR3.
  5, "2020-01-01", TRUE,
  5, "2009-01-01", TRUE,
  6, "2020-01-01", TRUE,
  2, "2020-01-01", TRUE
) |>
  dplyr::mutate(pregnancy_event_date = lubridate::as_date(pregnancy_event_date))

test_that("keep_pregnancy_dates() returns expected", {
  actual <- keep_pregnancy_dates(lpr2, lpr3)
  expect_equal(actual, expected_pregnancy_dates)
})
