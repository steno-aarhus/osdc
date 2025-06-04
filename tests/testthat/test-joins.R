# join_lpr2 -----------------------------------------------------------------

actual_lpr_diag <- tibble::tibble(
  recnum = rep(1:6, each = 2),
  c_diag = 1:12,
  c_diagtype = rep(c("A", "B"), 6)
)

actual_lpr_adm <- tibble::tibble(
  pnr = rep(1:2, 3),
  recnum = 2:7,
  c_spec = 1:6,
  d_inddto = c(
    "20230101",
    "20220101",
    "20210101",
    "20200101",
    "20190101",
    "20180101"
  ),
)

expected_lpr2 <- tibble::tibble(
  pnr = rep(1:2, length.out = 10, each = 2),
  recnum = rep(2:6, length.out = 10, each = 2),
  c_spec = rep(1:5, length.out = 10, each = 2),
  d_inddto = rep(
    c("20230101", "20220101", "20210101", "20200101", "20190101"),
    each = 2
  ),
  c_diag = 3:12,
  c_diagtype = rep(c("A", "B"), length.out = 10)
)

test_that("joining LPR2 correctly", {
  actual <- join_lpr2(
    lpr_adm = actual_lpr_adm,
    lpr_diag = actual_lpr_diag
  )

  expect_equal(actual, expected_lpr2)
})


# join_lpr3 -----------------------------------------------------------------

diagnoser <- tibble::tibble(
  dw_ek_kontakt = 1:6,
  diagnosekode = rep(c("DE10", "DO06", "DE11"), times = 2),
  diagnosetype = rep(c("A", "B", "B"), times = 2),
  senere_afkraeftet = rep(c("Nej", "Ja"), times = 3)
)

kontakter <- tibble::tibble(
  cpr = 1:6,
  dw_ek_kontakt = 1:6,
  dato_start = rep(c("20230101", "20220101"), times = 3),
  hovedspeciale_ans = rep(
    c("Unknown department", "Akut medicin", "Medicinsk endokrinologi"),
    times = 2
  )
)

expected_lpr3 <- tibble::tibble(
  pnr = c(1, 3, 5),
  date = rep(c("20230101"), times = 3),
  has_t1d = c(TRUE, FALSE, FALSE),
  has_t2d = c(FALSE, TRUE, FALSE),
  has_pregnancy_event = c(FALSE, FALSE, TRUE),
  is_endocrinology_department = c(FALSE, TRUE, FALSE),
  is_medical_department = c(FALSE, FALSE, TRUE),
  is_primary_diagnosis = c(TRUE, FALSE, FALSE),
) |>
  dplyr::mutate(date = lubridate::as_date(date))

test_that("joining LPR3 correctly", {
  actual <- join_lpr3(
    kontakter = kontakter,
    diagnoser = diagnoser
  )

  expect_equal(actual, expected_lpr3)
})
