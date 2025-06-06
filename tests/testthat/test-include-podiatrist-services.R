sysi <- tibble::tribble(
  ~pnr, ~barnmak, ~speciale, ~honuge,
  1000000000, 0, 54711, "1879", # removed since barnmark = 0
  2000000000, 1, 54800, "9207", # kept but deduplicated
  2000000000, 1, 54800, "9207", # kept but deduplicated
  3000000000, 1, 54005, "0752", # kept bc it's the first date for this person
  3000000000, 1, 54005, "2430", # removed bc it's the third date for this person
  4000000000, 1, 55000, "0044" # removed since speciale doesn't start with 54
)

sssy <- tibble::tribble(
  ~pnr, ~barnmak, ~speciale, ~honuge,
  2000000000, 1, 54800, "9207", # kept but deduplicated
  3000000000, 0, 10000, "1801", # removed since barnmark = 0
  3000000000, 1, 54005, "0830", # kept bc it's the second date for this person
  4000000000, 1, 76255, "1123", # removed since speciale doesn't start with 54
)

expected <- tibble::tribble(
  ~pnr, ~date, ~has_podiatrist_services,
  2000000000, lubridate::ymd("1992-02-10"), TRUE,
  3000000000, lubridate::ymd("2007-12-24"), TRUE,
  3000000000, lubridate::ymd("2008-07-21"), TRUE
)

test_that("sysi needs expected variables", {
  sysi <- sysi[-2]
  expect_error(include_podiatrist_services(sysi, sssy))
})

test_that("ssy needs expected variables", {
  sssy <- sssy[-2]
  expect_error(include_podiatrist_services(sysi, sssy))
})


test_that("those with inclusion are kept", {
  actual <- include_podiatrist_services(sysi, sssy)
  expect_equal(actual, expected)
})

test_that("casing of input variables doesn't matter", {
  sysi <- sysi |>
    dplyr::rename_with(\(columns) toupper(columns))
  sssy <- sssy |>
    dplyr::rename_with(\(columns) toupper(columns))
  actual <- include_podiatrist_services(sysi, sssy)
  expect_equal(actual, expected)
})
