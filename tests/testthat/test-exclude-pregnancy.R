excluded_pcos <- tibble::tribble(
  ~pnr, ~date, ~atc, ~contained_doses, ~has_gld_purchases, ~indication_code, ~no_pcos,
  # More than 40 weeks before pregnancy event (keep).
  1, "2000-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1, "2019-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # Exactly 40 weeks before pregnancy event (drop).
  1, "2009-04-28", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1, "2019-04-28", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # Within pregnancy interval (drop).
  1, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1, "2020-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # Exactly 12 weeks after pregnancy event (drop).
  1, "2010-04-27", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1, "2020-04-26", "A10BA02", 1.21, TRUE, "324314324", TRUE, # Not the date same as row above bc 2020 is a gap year.
  # More than 12 weeks after pregnancy event (keep).
  1, "2015-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1, "2025-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # No pregnancy event (keep).
  2, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

included_hba1c <- tibble::tribble(
  ~pnr, ~date, ~has_elevated_hba1c,
  # More than 40 weeks before pregnancy event (keep).
  1, "2000-01-01", TRUE,
  1, "2000-01-02", TRUE,
  # Exactly 40 weeks before pregnancy event (drop).
  1, "2009-04-28", TRUE,
  # Within pregnancy interval (drop).
  1, "2010-02-02", TRUE,
  # Exactly 12 weeks after pregnancy event (drop).
  1, "2010-04-27", TRUE,
  # More than 12 weeks after pregnancy event (keep).
  1, "2015-01-02", TRUE,
  # No pregnancy event (keep).
  3, "2010-02-02", TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

pregnancy_dates <- tibble::tribble(
  ~pnr, ~pregnancy_event_date, ~has_pregnancy_event,
  # Two pregnancy events for the same pnr to ensure that all events within both
  # pregnancy intervals are excluded.
  1, "2010-02-02", TRUE,
  1, "2020-02-02", TRUE,
  # Pregnancy event for pnr not in gld_purchases and included_hba1c (drop).
  4, "2010-01-01", TRUE,
) |>
  dplyr::mutate(pregnancy_event_date = lubridate::as_date(pregnancy_event_date))

expected <- tibble::tribble(
  ~pnr, ~date, ~contained_doses, ~has_gld_purchases, ~has_elevated_hba1c, ~no_pregnancy,
  # From excluded_pcos.
  1, "2000-01-01", 1.21, TRUE, NA, TRUE, # Same pnr and date as row from hba1c, both kept.
  1, "2019-01-01", 1.21, TRUE, NA, TRUE,
  1, "2015-01-01", 1.21, TRUE, NA, TRUE,
  1, "2025-01-01", 1.21, TRUE, NA, TRUE,
  2, "2010-02-02", 1.21, TRUE, NA, TRUE,
  # From included_hba1c.
  1, "2000-01-01", NA, NA, TRUE, TRUE, # Same pnr and date as row from excluded_pcos, both kept.
  1, "2000-01-02", NA, NA, TRUE, TRUE,
  1, "2015-01-02", NA, NA, TRUE, TRUE,
  3, "2010-02-02", NA, NA, TRUE, TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

test_that("pregnancy events are excluded as expected", {
  actual <- exclude_pregnancy(excluded_pcos, pregnancy_dates, included_hba1c)
  expect_equal(actual, expected)
})
