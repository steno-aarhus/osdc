inclusions <- tibble::tibble(
  pnr = c(1, 1, 1, 2, 2),
  date = as.Date(c(
    "1990-01-01",
    "1990-02-01",
    "2000-03-01",
    "2000-04-01",
    "2000-05-01"
  )),
  n_t1d_endocrinology = rep(0, 5),
  n_t2d_endocrinology = rep(0, 5),
  n_t1d_medical = rep(0, 5),
  n_t2d_medical = rep(0, 5),
  has_lpr_diabetes_diagnosis = rep(TRUE, 5),
  has_podiatrist_services = rep(TRUE, 5),
  atc = rep("A10", 5),
  contained_doses = rep(0, 5),
  has_gld_purchases = rep(FALSE, 5),
  has_elevated_hba1c = rep(TRUE, 5),
  no_pregnancy = rep(TRUE, 5)
)

actual <- create_inclusion_dates(inclusions)

test_that("number of rows decreases as expected", {
  expect_equal(nrow(actual), 3)
})

test_that("we have less stable inclusion dates than raw", {
  expect_less_than(
    sum(!is.na(actual$stable_inclusion_date)),
    sum(!is.na(actual$raw_inclusion_date))
  )
})
