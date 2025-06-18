bef <- tibble::tribble(
  ~koen, ~pnr, ~foed_dato,
  # Men (as defined by PNR)
  1, 1000000001, "1980-01-01",
  # Women (as defined by PNR)
  2, 2000000000, "1980-01-01",
  # No GLD purchases (excluded)
  1, 3000000001, "1980-01-01",
  2, 4000000000, "1980-01-01",
) |>
  dplyr::mutate(
    pnr = as.character(pnr),
    foed_dato = lubridate::as_date(foed_dato)
  )

gld_purchases <- tibble::tribble(
  ~pnr, ~date, ~atc, ~contained_doses, ~has_gld_purchases, ~indication_code,
  # Men (as defined by PNR)
  ## ATC matches criteria
  ### Age at purchase matches criteria (< 40)
  1000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324",
  1000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "0000092", # indication_code matches
  ### Age at purchase doesn't match (= 40)
  1000000001, "2020-02-02", "A10BA02", 1.21, TRUE, "324314324",
  1000000001, "2020-02-02", "A10BA02", 1.21, TRUE, "0000781", # indication_code matches
  ### Age at purchase doesn't match (> 40)
  1000000001, "2025-02-02", "A10BA02", 1.21, TRUE, "324314324",
  1000000001, "2025-02-02", "A10BA02", 1.21, TRUE, "0000276", # indication_code matches
  ## ATC doesn't match criteria
  ### Age at purchase matches criteria (< 40)
  1000000001, "2010-02-02", "A10", 1.21, TRUE, "324314324",
  1000000001, "2010-02-02", "A10", 1.21, TRUE, "0000092", # indication_code matches
  ### Age at purchase doesn't match (= 40)
  1000000001, "2020-02-02", "A10", 1.21, TRUE, "324314324",
  1000000001, "2020-02-02", "A10", 1.21, TRUE, "0000781", # indication_code matches
  ### Age at purchase doesn't match (> 40)
  1000000001, "2025-02-02", "A10", 1.21, TRUE, "324314324",
  1000000001, "2025-02-02", "A10", 1.21, TRUE, "0000276", # indication_code matches

  # Women (as defined by PNR)
  ## ATC matches criteria
  ### Age at purchase matches criteria (< 40)
  2000000000, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", # excluded
  2000000000, "2010-02-02", "A10BA02", 1.21, TRUE, "0000092", # indication_code matches, excluded
  ### Age at purchase doesn't match (= 40)
  2000000000, "2020-02-02", "A10BA02", 1.21, TRUE, "324314324",
  2000000000, "2020-02-02", "A10BA02", 1.21, TRUE, "0000781", # indication_code matches, excluded
  ### Age at purchase doesn't match (> 40)
  2000000000, "2025-02-02", "A10BA02", 1.21, TRUE, "324314324",
  2000000000, "2025-02-02", "A10BA02", 1.21, TRUE, "0000276", # indication_code matches, excluded
  ## ATC doesn't match criteria
  ### Age at purchase matches criteria (< 40)
  2000000000, "2010-02-02", "A10", 1.21, TRUE, "324314324",
  2000000000, "2010-02-02", "A10", 1.21, TRUE, "0000092", # indication_code matches
  ### Age at purchase doesn't match (= 40)
  2000000000, "2020-02-02", "A10", 1.21, TRUE, "324314324",
  2000000000, "2020-02-02", "A10", 1.21, TRUE, "0000781", # indication_code matches
  ### Age at purchase doesn't match (> 40)
  2000000000, "2025-02-02", "A10", 1.21, TRUE, "324314324",
  2000000000, "2025-02-02", "A10", 1.21, TRUE, "0000276", # indication_code matches
  # Not in BEF (excluded)
  5000000000, "2010-01-01", "A10", 1.21, TRUE, "0000276",
) |>
  dplyr::mutate(pnr = as.character(pnr), date = lubridate::as_date(date))

expected <- tibble::tribble(
  ~pnr, ~date, ~atc, ~contained_doses, ~has_gld_purchases, ~indication_code, ~no_pcos,
  # Men (as defined by PNR)
  ## ATC matches criteria
  ### Age at purchase matches criteria (< 40)
  1000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2010-02-02", "A10BA02", 1.21, TRUE, "0000092", TRUE, # indication_code matches
  ### Age at purchase doesn't match (= 40)
  1000000001, "2020-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2020-02-02", "A10BA02", 1.21, TRUE, "0000781", TRUE, # indication_code matches
  ### Age at purchase doesn't match (> 40)
  1000000001, "2025-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2025-02-02", "A10BA02", 1.21, TRUE, "0000276", TRUE, # indication_code matches
  ## ATC doesn't match criteria
  ### Age at purchase matches criteria (< 40)
  1000000001, "2010-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2010-02-02", "A10", 1.21, TRUE, "0000092", TRUE, # indication_code matches
  ### Age at purchase doesn't match (= 40)
  1000000001, "2020-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2020-02-02", "A10", 1.21, TRUE, "0000781", TRUE, # indication_code matches
  ### Age at purchase doesn't match (> 40)
  1000000001, "2025-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  1000000001, "2025-02-02", "A10", 1.21, TRUE, "0000276", TRUE, # indication_code matches

  # Women (as defined by PNR)
  ## ATC matches criteria
  ### Age at purchase matches criteria (< 40)
  ### Age at purchase doesn't match (= 40)
  2000000000, "2020-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  ### Age at purchase doesn't match (> 40)
  2000000000, "2025-02-02", "A10BA02", 1.21, TRUE, "324314324", TRUE,
  ## ATC doesn't match criteria
  ### Age at purchase matches criteria (< 40)
  2000000000, "2010-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  2000000000, "2010-02-02", "A10", 1.21, TRUE, "0000092", TRUE, # indication_code matches
  ### Age at purchase doesn't match (= 40)
  2000000000, "2020-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  2000000000, "2020-02-02", "A10", 1.21, TRUE, "0000781", TRUE, # indication_code matches
  ### Age at purchase doesn't match (> 40)
  2000000000, "2025-02-02", "A10", 1.21, TRUE, "324314324", TRUE,
  2000000000, "2025-02-02", "A10", 1.21, TRUE, "0000276", TRUE, # indication_code matches
) |>
  dplyr::mutate(pnr = as.character(pnr), date = lubridate::as_date(date))


test_that("bef needs expected variables", {
  bef <- bef[-2]
  expect_error(exclude_potential_pcos(gld_purchases, bef))
})

test_that("potential pcos instances are excluded", {
  actual <- exclude_potential_pcos(gld_purchases, bef)
  expect_equal(actual, expected)
})
