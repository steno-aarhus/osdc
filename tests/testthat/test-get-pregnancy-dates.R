lpr2 <- tibble::tribble(
  ~c_spec, ~pnr, ~recnum, ~d_inddto, ~c_diagtype, ~c_diag,
  # no pregnancy diagnosis (drop)
  46, 164409653234, 942848630572354208, "20150812", "A", "E9511",
  # pregnancy diagnosis (keep)
  58, 952443913885, 069594786879610784, "20150710", "B", "DO00",
  # duplicate PNR, pregnancy diagnosis (keep both)
  31, 952443913885, 470350823177866548, "20000710", "B", "DO04",
)

lpr3 <- tibble::tribble(
  ~pnr, ~dw_ek_kontakt, ~dato_start, ~hovedspeciale_ans, ~diagnosekode, ~diagnosetype, ~senere_afkraeftet,
  # pregnancy diagnosis (keep)
  120172052967, 371073944504254886, "20050411", "Oftalmologi", "DE470", "A", "Nej",
  # pregnancy diagnosis same date as row above (only keep one),
  120172052967, 371073944504254886, "20050411", "Oftalmologi", "DO80", "A", "Nej",
  # duplicate PNR from LPR2, pregnancy diagnosis (keep)
  164409653234, 849133686529524253, "19811226", "Psykiatri", "DZ33", "B", "Nej",
  # duplicate PNR from LPR2, pregnancy diagnosis (keep)
  164409653234, 849133686529524253, "19811226", "Psykiatri", "E9511", "B", "Nej"
)

expected_pregnancy_dates <- tibble::tribble(
  ~pnr, ~pregnancy_event_date, ~has_pregnancy_event,
  # from LPR2
  952443913885,"20150710", TRUE,
  952443913885, "20000710", TRUE,
  # from LPR3
  120172052967, "20050411", TRUE,
  164409653234, "19811226", TRUE
) |>
  dplyr::mutate(pregnancy_event_date = lubridate::as_date(pregnancy_event_date))

test_that("get_pregnancy_dates() returns expected", {
  actual <- get_pregnancy_dates(lpr2, lpr3)
  expect_equal(actual, expected_pregnancy_dates)
})
