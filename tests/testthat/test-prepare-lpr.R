# prepare_lpr2 -----------------------------------------------------------------

lpr_diag <- tibble::tribble(
  ~recnum, ~c_diag, ~c_diagtype,
  # General diabetes
  "1101", "DE12", "A",
  "1102", "DE13", "A",
  "1103", "DE14", "B",
  # T1D primary diagnosis
  "1104", "DE10", "A",
  "1105", "249", "A",
  # T1D secondary diagnosis
  "1106", "DE10", "B",
  "1107", "249", "B",
  # T2D primary diagnosis
  "1108", "DE11", "A",
  "1109", "250", "A",
  # T2D secondary diagnosis
  "1110", "DE11", "B",
  "1111", "250", "B",
  # Pregnancy event
  "1112", "DO03", "A",
  "1113", "DO80", "B",
  "1114", "DZ33", "A",
  # Not included
  "1001", "DO030", "C",
  "1002", "DO07", "A",
  "1003", "DZ32", "B",
  "1004", "DE15", "A",
  "1005", "248", "A",
  "1006", "248", "B",
  "1007", "251", "B",
  "1008", "DO85", "B",
  "1009", "DZ34", "A",
  "1010", "DZ38", "A",
  "1011", "DE1", "B",
  "1012", "DZ3", "A"
)

lpr_adm <- tibble::tribble(
  ~recnum, ~pnr, ~c_spec, ~d_inddto,
  # T1D primary with endocrinology department
  "1104", "1", "08", "20230101",
  "1105", "2", "08", "20230101",
  # T1D secondary with endocrinology department
  "1106", "3", "08", "20220101",
  "1107", "4", "08", "20220101",
  # T2D primary with endocrinology department
  "1108", "5", "08", "20200101",
  "1109", "6", "08", "20200101",
  # T2D secondary with endocrinology department
  "1110", "7", "08", "20200101",
  "1111", "8", "08", "20200101",
  # T1D primary with other medical department
  "1104", "9", "09", "20230101",
  "1105", "10", "09", "20230101",
  # T1D secondary with other medical department
  "1106", "11", "09", "20220101",
  "1107", "12", "19", "20220101",
  # T2D primary with other medical department
  "1108", "13", "09", "20200101",
  "1109", "14", "19", "20200101",
  # T2D secondary with other medical department
  "1110", "15", "09", "20200101",
  "1111", "16", "19", "20200101",
  # Pregnancy event with endocrinology department
  "1112", "17", "08", "20230101",
  "1113", "18", "08", "20220101",
  "1114", "19", "08", "20200101",
  # Pregnancy event with other medical department
  "1112", "20", "09", "20230101",
  "1113", "21", "19", "20220101",
  "1114", "22", "19", "20200101",
  # Pregnancy with T2D primary with endocrinology department
  "1108", "21", "08", "20220102",
  # Pregnancy with T2D secondary with endocrinology department
  "1110", "17", "08", "20230102",
  # Pregnancy with T1D primary with endocrinology department
  "1104", "18", "08", "20220102",
  # Pregnancy with T1D secondary with other medical department
  "1106", "20", "20", "20230102",
  # General diabetes primary with endocrinology department
  "1101", "23", "08", "20230101",
  "1102", "24", "08", "20220101",
  # General diabetes secondary with endocrinology department
  "1103", "25", "08", "20200101",
  # General diabetes primary with other medical department
  "1101", "26", "09", "20230101",
  "1102", "27", "19", "20220101",
  # General diabetes secondary with other medical department
  "1103", "28", "09", "20200101",
  # Not included
  "1001", "29", "08", "20230101",
  "1002", "30", "08", "20220101",
  "1003", "31", "08", "20200101",
  "1004", "32", "08", "20200101",
  "1005", "33", "08", "20200101",
  "1006", "34", "08", "20200101",
  "1007", "35", "08", "20200101",
  "1008", "36", "08", "20200101",
  "1009", "37", "08", "20200101",
  "1010", "38", "08", "20200101",
  "1011", "39", "08", "20200101",
  "1012", "40", "08", "20200101",
  "1012", "41", "07", "20200101",
  "1012", "42", "31", "20200101"
)

expected_lpr2 <- tibble::tribble(
  ~pnr, ~date, ~is_primary_dx, ~is_diabetes_code, ~is_t1d_code, ~is_t2d_code, ~is_endocrinology_department, ~is_medical_department, ~is_pregnancy_code,
  # T1D primary diagnosis with endocrinology department
  "1", "2023-01-01", TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  "2", "2023-01-01", TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  # T1D secondary diagnosis with endocrinology department
  "3", "2022-01-01", FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  "4", "2022-01-01", FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  # T2D primary diagnosis with endocrinology department
  "5", "2020-01-01", TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  "6", "2020-01-01", TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  # T2D secondary diagnosis with endocrinology department
  "7", "2020-01-01", FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  "8", "2020-01-01", FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  # T1D primary diagnosis with other medical department
  "9", "2023-01-01", TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,
  "10", "2023-01-01", TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,
  # T1D secondary diagnosis with other medical department
  "11", "2022-01-01", FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,
  "12", "2022-01-01", FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,
  # T2D primary diagnosis with other medical department
  "13", "2020-01-01", TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
  "14", "2020-01-01", TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
  # T2D secondary diagnosis with other medical department
  "15", "2020-01-01", FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
  "16", "2020-01-01", FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE,
  # Pregnancy event with endocrinology department
  "17", "2023-01-01", TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE,
  "18", "2022-01-01", FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE,
  "19", "2020-01-01", TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, TRUE,
  # Pregnancy event with other medical department
  "20", "2023-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  "21", "2022-01-01", FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  "22", "2020-01-01", TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE,
  # Pregnancy with T2D primary with endocrinology department
  "21", "2022-01-02", TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  # Pregnancy with T2D secondary with endocrinology department
  "17", "2023-01-02", FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, FALSE,
  # Pregnancy with T1D primary with endocrinology department
  "18", "2022-01-02", TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, FALSE,
  # Pregnancy with T1D secondary with other medical department
  "20", "2023-01-02", FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE,
  # General diabetes primary with endocrinology department
  "23", "2023-01-01", TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE,
  "24", "2022-01-01", TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE,
  # General diabetes secondary with endocrinology department
  "25", "2020-01-01", FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE,
  # General diabetes primary with other medical department
  "26", "2023-01-01", TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
  "27", "2022-01-01", TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE,
  # General diabetes secondary with other medical department
  "28", "2020-01-01", FALSE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE
) |>
  dplyr::mutate(date = lubridate::as_date(date)) |>
  dplyr::arrange(pnr, date)

test_that("preparing LPR2 correctly", {
  actual <- prepare_lpr2(
    lpr_adm = lpr_adm,
    lpr_diag = lpr_diag
  ) |>
    dplyr::arrange(pnr, date)

  expect_equal(actual, expected_lpr2)
})


# prepare_lpr3 -----------------------------------------------------------------

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
  is_primary_dx = c(TRUE, FALSE, FALSE),
  is_diabetes_code = c(TRUE, TRUE, FALSE),
  is_t1d_code = c(TRUE, FALSE, FALSE),
  is_t2d_code = c(FALSE, TRUE, FALSE),
  is_endocrinology_dept = c(FALSE, TRUE, FALSE),
  is_medical_dept = c(FALSE, FALSE, TRUE),
  is_pregnancy_code = c(FALSE, FALSE, TRUE),
) |>
  dplyr::mutate(date = lubridate::as_date(date))

test_that("joining LPR3 correctly", {
  actual <- prepare_lpr3(
    kontakter = kontakter,
    diagnoser = diagnoser
  )

  expect_equal(actual, expected_lpr3)
})
