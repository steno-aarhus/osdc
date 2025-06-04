excluded_pcos <- tibble::tribble(
  ~pnr, ~date, ~atc, ~contained_doses, ~has_gld_purchases, ~indication_code, ~no_pcos,
  # more than 40 weeks before pregnancy event (keep)
  1000000001, "2000-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # exactly 40 weeks before pregnancy event (drop)
  1000000001, "2009-04-28", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # within pregnancy period (drop)
  1000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # exactly 12 weeks after pregnancy event (drop)
  1000000001, "2010-04-27", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # more than 12 weeks after pregnancy event (keep)
  1000000001, "2020-01-01", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  # no pregnancy event (keep)
  2000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

included_hba1c <- tibble::tribble(
  ~pnr, ~date, ~has_elevated_hba1c,
  # more than 40 weeks before pregnancy event (keep)
  1000000001, "2000-01-01", TRUE,
  # exactly 40 weeks before pregnancy event (drop)
  1000000001, "2009-04-28", TRUE,
  # within pregnancy period (drop)
  1000000001, "2010-02-02", TRUE,
  # exactly 12 weeks after pregnancy event (drop)
  1000000001, "2010-04-27", TRUE,
  # more than 12 weeks after pregnancy event (keep)
  1000000001, "2020-01-01", TRUE,
  # no pregnancy event (keep)
  3000000001, "2010-02-02", TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

pregnancy_dates <- tibble::tribble(
  ~pnr, ~pregnancy_event_date, ~has_pregnancy_event,
  1000000001, "2010-02-02", TRUE,
) |>
  dplyr::mutate(pregnancy_event_date = lubridate::as_date(pregnancy_event_date))

expected <- tibble::tribble(
  ~pnr, ~date, ~atc, ~contained_doses, ~has_gld_purchases, ~has_elevated_hba1c, ~no_pregnancy,
  1000000001, "2000-01-01", "A10BA02", 1.21, TRUE, TRUE, TRUE,
  1000000001, "2020-01-01", "A10BA02", 1.21, TRUE, TRUE, TRUE,
  2000000001, "2010-02-02", "A10BA02", 1.21, TRUE, NA, TRUE,
  3000000001, "2010-02-02", NA, NA, NA, TRUE, TRUE,
) |>
  dplyr::mutate(date = lubridate::as_date(date))

test_that("pregnancy events are excluded as expected", {
  actual <- exclude_pregnancy(excluded_pcos, pregnancy_dates, included_hba1c)
  expect_equal(actual, expected)
})
