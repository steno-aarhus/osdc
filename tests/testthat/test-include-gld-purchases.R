constants <- tibble::tibble(
  pnr = "2132131231",
  eksd = "20210101",
  volume = 1.1,
  apk = 1.1,
  indo = "324314324"
)

lmdb <- tibble::tribble(
  ~atc,
  "A10A23",
  "A10",
  "A10C",
  "A10B",
  "A10AE56",
  "A10B02",
  "A11",
  "A21",
  "B10A10",
) |>
  dplyr::bind_cols(constants)

expected <- tibble::tribble(
  ~atc, ~is_insulin_gld_code,
  "A10A23", TRUE,
  "A10", FALSE,
  # This ATC doesn't exist, but is added to be certain
  # the function correctly identifies the drug classes.
  "A10C", FALSE,
  "A10B", FALSE,
  "A10AE56", FALSE,
  "A10B02", FALSE
) |>
  dplyr::bind_cols(constants) |>
  dplyr::rename(date = eksd, indication_code = indo) |>
  dplyr::mutate(
    contained_doses = volume * apk,
    has_gld_purchases = TRUE,
  ) |>
  dplyr::select(-volume, -apk) |>
  dplyr::relocate(
    pnr,
    date,
    atc,
    contained_doses,
    has_gld_purchases,
    indication_code,
    is_insulin_gld_code
  )

test_that("dataset needs expected variables", {
  actual <- lmdb[-2]
  expect_error(include_gld_purchases(actual))
})

test_that("those with inclusion are kept", {
  actual <- include_gld_purchases(lmdb)
  expect_equal(actual, expected)
})
