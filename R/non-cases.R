#' List of non-cases to test the diabetes classification algorithm
#'
#' This function generates a list of tibbles representing the Danish health
#' registers and the data necessary to run the algorithm. The dataset contains
#' individuals who should *not* be included in the final classified cohort.
#'
#' The generated data is used in `testthat` tests to ensure the algorithm
#' behaves as expected under a wide range of conditions, but it is also intended
#' to be explored by users to better understand how the algorithm logic works
#' and to be shown in the documentation.
#'
#' @return A named list of 9  [tibble::tibble()] objects, each representing a
#'   different health register: `bef`, `lmdb`, `lpr_adm`, `lpr_diag`,
#'   `kontakter`, `diagnoser`, `sysi`, `sssy`, and `lab_forsker`.
#' @export
#'
#' @examples
#' non_cases()
non_cases <- function() {
  bef <- tibble::tribble(
    ~pnr, ~koen, ~foed_dato,
    "nc_pcos_1", 2, "19800101",
    "nc_pcos_2", 2, "19800101",
    "nc_pcos_3", 2, "19800101",
    "nc_preg_1", 2, "19800101",
    "nc_preg_2", 2, "19800101",
    "nc_preg_3", 2, "19800101",
    "nc_preg_4", 2, "19800101",
  ) |>
    dplyr::mutate(koen = as.integer(.data$koen))

  lmdb <- tibble::tribble(
    ~pnr, ~volume, ~eksd, ~atc, ~apk, ~indo,
    "nc_pcos_1", 10, "20210101", "A10BA02", 5, "0000276",
    "nc_pcos_2", 10, "20190101", "A10BA02", 5, "0000276",
    "nc_pcos_3", 10, "20190101", "A10BA02", 5, "0000276",
    "nc_preg_1", 10, "20180101", "A10", 5, "0000000",
    "nc_preg_2", 10, "20180101", "A10", 5, "0000000",
    "nc_preg_3", 10, "20200101", "A10", 5, "0000000",
    "nc_preg_4", 10, "20200101", "A10", 5, "0000000",
  )

  # LPR2 is before 2019
  lpr_adm <- tibble::tribble(
    ~pnr, ~c_spec, ~recnum, ~d_inddto,
    "nc_pcos_1", "08", "1", "20180101",
    "nc_pcos_2", "08", "1", "20170101",
    "nc_pcos_3", "08", "1", "20170101",
    "nc_preg_1", "08", "1", "20180101",
    "nc_preg_2", "08", "1", "20180101",
    "nc_preg_1", "08", "2", "20180101",
    "nc_preg_2", "08", "3", "20180101",
  )

  lpr_diag <- tibble::tribble(
    ~recnum, ~c_diag, ~c_diagtype,
    # diagnosis noise (not diabetes)
    "1", "149", "A",
    # Pregnancy
    "2", "DO00", "A",
    "3", "DZ33", "A",
  )

  # LPR3 is from 2019 onwards
  kontakter <- tibble::tribble(
    ~cpr, ~dw_ek_kontakt, ~hovedspeciale_ans, ~dato_start,
    "nc_pcos_1", "1", "medicinsk endokrinologi", "20210101",
    "nc_pcos_2", "1", "medicinsk endokrinologi", "20190101",
    "nc_pcos_3", "1", "medicinsk endokrinologi", "20190101",
    "nc_preg_3", "1", "abc", "20200101",
    "nc_preg_4", "1", "abc", "20200101",
    "nc_preg_3", "2", "abc", "20200101",
    "nc_preg_4", "3", "abc", "20200101",
  )

  diagnoser <- tibble::tribble(
    ~dw_ek_kontakt, ~diagnosekode, ~diagnosetype, ~senere_afkraeftet,
    # diagnosis noise (not diabetes)
    "1", "DI10", "A", "Nej",
    # Pregnancy
    "2", "DO00", "A", "Nej",
    "3", "DZ33", "A", "Nej",
  )

  sysi <- tibble::tribble(
    ~pnr, ~barnmak, ~speciale, ~honuge,
    # health service noise data (not diabetes-related)
    "nc_pcos_1", 0, "53", "2101",
    "nc_pcos_2", 0, "53", "1901",
    "nc_pcos_3", 0, "53", "1901",
    "nc_preg_1", 0, "53", "2001",
    "nc_preg_2", 0, "53", "2001",
    "nc_preg_3", 0, "53", "2001",
    "nc_preg_4", 0, "53", "2001",
  ) |>
    dplyr::mutate(barnmak = as.integer(.data$barnmak))

  sssy <- tibble::tribble(
    ~pnr, ~barnmak, ~speciale, ~honuge,
    # health service noise data (not diabetes-related)
    "nc_pcos_1", 0, "53", "2101",
    "nc_pcos_2", 0, "53", "1901",
    "nc_pcos_3", 0, "53", "1901",
    "nc_preg_1", 0, "53", "2001",
    "nc_preg_2", 0, "53", "2001",
    "nc_preg_3", 0, "53", "2001",
    "nc_preg_4", 0, "53", "2001",
  ) |>
    dplyr::mutate(barnmak = as.integer(.data$barnmak))

  lab_forsker <- tibble::tribble(
    ~patient_cpr, ~samplingdate, ~analysiscode, ~value,
    "nc_pcos_1", "20210101", "NPU27300", 48,
    "nc_pcos_2", "20190101", "NPU03835", 6.5,
    "nc_pcos_3", "20190101", "NPU03835", 6.5,
    "nc_preg_1", "20170301", "NPU27300", 48,
    "nc_preg_2", "20180301", "NPU03835", 6.5,
    "nc_preg_3", "20190301", "NPU03835", 6.5,
    "nc_preg_4", "20200301", "NPU27300", 48,
  )

  # Combine all tibbles into a named list -----

  nc <- list(
    bef = bef,
    lmdb = lmdb,
    lpr_adm = lpr_adm,
    lpr_diag = lpr_diag,
    kontakter = kontakter,
    diagnoser = diagnoser,
    sysi = sysi,
    sssy = sssy,
    lab_forsker = lab_forsker
  )

  # Make the data bigger with simulated data to resolve issues of size
  sim_data <- registers() |>
    names() |>
    simulate_registers(n = 10000)

  sim_data |>
    names() |>
    purrr::map(\(name) {
      out <- list(
        dplyr::bind_rows(nc[[name]], sim_data[[name]])
      )
      out <- rlang::set_names(out, name)
    }) |>
    purrr::flatten()
}

#' Description of the different non-cases included in `non_cases()`
#'
#' All cases, aside from what would exclude them from being classified as
#' described in the metadata here, would otherwise be classified as having
#' diabetes.
#'
#' @returns A named list of character strings, where each name corresponds to a
#'  non-case PNR in the dataset generated by `non_cases()`.
#' @export
#'
#' @examples
#' non_cases_metadata()
non_cases_metadata <- function() {
  list(
    nc_pcos_1 = "Woman taking metformin, older than 40, and has an indication code. No other purchases of metformin.",
    nc_pcos_2 = "Woman taking metformin, younger than 40, and doesn't have the indication code. No other purchases of metformin.",
    nc_pcos_3 = "Woman taking metformin, younger than 40, and has an indication code. No other purchases of metformin.",
    nc_preg_1 = "Woman with high HbA1c measured <40 weeks before giving birth or having a miscarriage (from LPR2).",
    nc_preg_2 = "Woman with high HbA1c measured <12 weeks after giving birth or having a miscarriage (from LPR2).",
    nc_preg_3 = "Woman with high HbA1c measured <40 weeks before giving birth or having a miscarriage (from LPR3).",
    nc_preg_4 = "Woman with high HbA1c measured <12 weeks after giving birth or having a miscarriage (from LPR3)."
  )
}
