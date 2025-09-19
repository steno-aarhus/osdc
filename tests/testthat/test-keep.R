# keep_diabetes_diagnoses() -----
register_data <- simulate_registers(
  c("lpr_diag", "lpr_adm", "diagnoser", "kontakter"),
  n = 1000
)

lpr2 <- prepare_lpr2(
  lpr_adm = register_data$lpr_adm,
  lpr_diag = register_data$lpr_diag
) |>
  # At least one true case
  dplyr::add_row(
    pnr = "99",
    date = as.Date("2020-01-01"),
    is_t1d_code = TRUE,
    is_t2d_code = FALSE,
    is_primary_diagnosis = TRUE,
    is_medical_dept = FALSE,
    is_diabetes_code = TRUE,
    is_endocrinology_dept = TRUE
  )

lpr3 <- prepare_lpr3(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser
)

actual <- keep_diabetes_diagnoses(
  lpr2 = lpr2,
  lpr3 = lpr3
) |>
  add_t1d_diagnoses_cols()

test_that("creates a data.frame output", {
  expect_contains(class(actual), "data.frame")
})

test_that("at least one 'case' is kept", {
  expect_equal(nrow(dplyr::count(actual, has_majority_t1d_diagnoses)), 2)
})

# keep_gld_purchases() -----

lmdb <- simulate_registers("lmdb", 1000)[[1]]

test_that("creates a data.frame output", {
  actual <- keep_gld_purchases(lmdb)
  expect_contains(class(actual), "data.frame")
})

# keep_hba1c() -----

lab_forsker <- tibble::tribble(
  ~patient_cpr, ~samplingdate, ~analysiscode, ~value,
  # Three events, all of which should be kept (except duplicates)
  "498718589800", "20230101", "NPU27300", 49,
  "498718589800", "20210101", "NPU27300", 49,
  "498718589800", "20220101", "NPU27300", 49,
  "498718589801", "20230101", "NPU03835", 6.6,
  "498718589802", "20230101", "NPU03835", 6.3,
  "498718589803", "20230101", "NPU27300", 47,
  # Duplicate patient_cpr but with the old units.
  "498718589803", "20210101", "NPU27300", 49,
  "498718589803", "20220101", "NPU03835", 6.5,
  # Duplicate patient_cpr when old and new units are the same date.
  "498718589805", "20000101", "NPU03835", 6.5,
  "498718589805", "20000101", "NPU27300", 49,
  # Duplicate but with old below threshold and new above it.
  "498718589806", "20000101", "NPU03835", 6.3,
  "498718589806", "20000101", "NPU27300", 49,
  # Duplicate but with new below threshold and old above it.
  "498718589807", "20200101", "NPU03835", 6.6,
  "498718589807", "20200101", "NPU27300", 47,
  "498718589808", "20220101", "NPU00000", 100,
  "498718589809", "20220101", "NPU00000", 5,
  # If there are NA values, they should be ignored.
  "498718589809", "20220101", "NPU00000", NA,
  "498718589809", "20220101", NA, 5,
  "498718589809", NA, "NPU00000", 5,
  NA, "20220101", "NPU00000", 5
)

expected <- tibble::tribble(
  ~pnr, ~date,
  "498718589800", "20230101",
  "498718589800", "20210101",
  "498718589800", "20220101",
  "498718589801", "20230101",
  "498718589803", "20210101",
  "498718589803", "20220101",
  "498718589805", "20000101",
  "498718589806", "20000101",
  "498718589807", "20200101"
)

test_that("dataset needs expected variables", {
  actual <- lab_forsker[-2]
  expect_error(keep_hba1c(actual))
})

test_that("those with inclusion are kept", {
  actual <- keep_hba1c(lab_forsker)
  expect_equal(actual, expected)
})

# keep_podiatrist_services() -----

sysi <- tibble::tribble(
  ~pnr, ~barnmak, ~speciale, ~honuge,
  1000000000, 1, 54711, "1879", # removed since barnmark = 1
  2000000000, 0, 54800, "9207", # kept but deduplicated
  2000000000, 0, 54800, "9207", # kept but deduplicated
  3000000000, 0, 54005, "0752", # kept bc it's the first date for this person
  3000000000, 0, 54005, "2430", # removed bc it's the third date for this person
  4000000000, 0, 55000, "0044" # removed since speciale doesn't start with 54
)

sssy <- tibble::tribble(
  ~pnr, ~barnmak, ~speciale, ~honuge,
  2000000000, 0, 54800, "9207", # kept but deduplicated
  3000000000, 1, 10000, "1801", # removed since barnmark = 1
  3000000000, 0, 54005, "0830", # kept bc it's the second date for this person
  4000000000, 0, 76255, "1123", # removed since speciale doesn't start with 54
)

expected <- tibble::tribble(
  ~pnr, ~date,
  2000000000, lubridate::ymd("1992-02-10"),
  3000000000, lubridate::ymd("2007-12-24"),
  3000000000, lubridate::ymd("2008-07-21")
)

test_that("sysi needs expected variables", {
  sysi <- sysi[-2]
  expect_error(keep_podiatrist_services(sysi, sssy))
})

test_that("ssy needs expected variables", {
  sssy <- sssy[-2]
  expect_error(keep_podiatrist_services(sysi, sssy))
})


test_that("those with inclusion are kept", {
  actual <- keep_podiatrist_services(sysi, sssy)
  expect_equal(actual, expected)
})
