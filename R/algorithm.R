#' A list of the algorithmic logic for each criteria underlying osdc.
#'
#' This nested list contains the logic details of the algorithm for specific
#' inclusion and exclusion criteria.
#'
#' @format
#' Is a list with nested lists that have these named elements:
#'
#' \describe{
#'  \item{register}{Optional. The register used for this criteria.}
#'  \item{name}{The inclusion or exclusion criteria name.}
#'  \item{title}{The title to use when displaying the algorithmic logic in tables.}
#'  \item{logic}{The logic for the criteria.}
#'  \item{comments}{Some additional comments on the criteria.}
#' }
#'
#' @returns A nested list with the algorithmic logic for each criteria. Contains
#'   fields `register`, `title`, `logic`, and `comments`.
#' @export
#'
#' @seealso See the `vignette("algorithm")` for the logic used to filter these
#'   patients.
#' @examples
#' algorithm()$hba1c
#' algorithm()$gld$logic
algorithm <- function() {
  list(
    hba1c = list(
      register = "lab_forsker",
      title = "HbA1c inclusion",
      logic = "(analysiscode == 'NPU27300' AND value >= 48) OR (analysiscode == 'NPU03835' AND value >= 6.5)",
      comments = "Is the IFCC units for NPU27300 and DCCT units for NPU03835."
    ),
    gld = list(
      register = "lmdb",
      title = "Glucose-lowering drug inclusion",
      logic = "atc =~ '^A10' AND NOT (atc =~ '^(A10BJ|A10BK01|A10BK03)')",
      comments = "Do not keep GLP-RAs or dapagliflozin/empagliflozin drugs."
    ),
    lpr2_needed_codes = list(
      register = "lpr_diag",
      title = "Required LPR2 diagnoses codes",
      logic = "c_diag =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37]|DE1[0-4]|249|250)' AND (c_diagtype == 'A' OR c_diagtype == 'B')",
      comments = "'A' `c_diagtype` means primary diagnosis."
    ),
    lpr2_has_diabetes = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for any diabetes",
      logic = "c_diag =~ '^(DE1[0-4]|249|250)'",
      comments = ""
    ),
    lpr2_has_t1d = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for T1D",
      logic = "c_diag =~ '^(DE10|249)'",
      comments = ""
    ),
    lpr2_has_t2d = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for T2D",
      logic = "c_diag =~ '^(DE11|250)'",
      comments = ""
    ),
    lpr2_is_endocrinology_department = list(
      register = "lpr_adm",
      title = "LPR2 endocrinology department",
      logic = "c_spec == 8",
      comments = "`TRUE` when the department is endocrinology where diagnosis took place."
    ),
    lpr2_is_medical_department = list(
      register = "lpr_adm",
      title = "LPR2 other medical department",
      logic = "c_spec %in% 9:30",
      comments = "`TRUE` when it is other medical departments where diagnosis took place."
    ),
    lpr2_has_pregnancy_event = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for pregnancy-related outcomes",
      logic = "c_diag =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37])'",
      comments = "These are recorded pregnancy endings like live births and miscarriages."
    ),
    lpr3_is_endocrinology_department = list(
      register = "kontakter",
      title = "LPR3 endocrinology department",
      # TODO: We will need to make sure the Unicode character gets selected properly in real data.
      logic = "na_if(hovedspeciale_ans, NOT (hovedspeciale_ans %in% c('medicinsk endokrinologi', 'blandet medicin og kirurgi', 'intern medicin', 'geriatri', 'hepatologi', 'h\u00e6matologi', 'infektionsmedicin', 'kardiologi', 'medicinsk allergologi', 'medicinsk gastroenterologi', 'medicinsk lungesygdomme', 'nefrologi', 'reumatologi', 'palliativ medicin', 'akut medicin', 'dermato-venerologi', 'neurologi', 'onkologi', 'fysiurgi', 'tropemedicin'))) == 'medicinsk endokrinologi'",
      comments = "`TRUE` when the department is endocrinology, `FALSE` when it is other medical departments, and missing in all other cases."
    ),
    lpr3 = list(
      register = "diagnoser",
      title = "Relevant LPR3 diagnoses codes",
      logic = "diagnosekode =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37]|DE1[0-4])' AND (diagnosetype == 'A' OR diagnosetype == 'B') AND (senere_afkraeftet == 'Nej')",
      comments = "`A` `diagnosekode` means primary diagnosis and `senere_afkraeftet` means diagnosis was later retracted."
    ),
    lpr3_has_t1d = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for T1D",
      logic = "diagnosekode =~ '^(DE10)'",
      comments = ""
    ),
    lpr3_has_t2d = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for T2D",
      logic = "diagnosekode =~ '^(DE11)'",
      comments = ""
    ),
    has_pregnancy_event = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for pregnancy-related outcomes",
      logic = "diagnosekode =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37])'",
      comments = "These are recorded pregnancy endings like live births and miscarriages."
    ),
    no_pregnancy = list(
      register = NA,
      title = "Remove events within a potential pregnancy period",
      logic = "NOT (is_pregnancy_code AND has_elevated_hba1c AND (date >= (pregnancy_event_date - weeks(40)) OR date <= (pregnancy_event_date + weeks(12)))",
      comments = ""
    ),
    podiatrist_services = list(
      register = NA,
      title = "Podiatrist services",
      logic = "speciale =~ '^54' AND barnmak != 0",
      # TODO: Explain what barnmark 0 means
      comments = "`barnmak` means the services were provided to a child of the individual."
    ),
    no_potential_pcos = list(
      register = NA,
      title = "No potential PCOS",
      logic = "NOT (koen == 2 AND atc =~ '^A10BA02$' AND ((date - foed_dato) < years(40) OR indication_code %in% c('0000092', '0000276', '0000781')))",
      comments = "Woman is defined as 2 in `koen`."
    )
  )
}

#' Get the criteria algorithmic logic and convert to an R logic condition.
#'
#' @param criteria The name of the inclusion or exclusion criteria to use.
#' @param algorithm The list of algorithmic logic for each criteria. Default is
#'   `algorithm()`. This argument is used for testing only.
#'
#' @return A character string.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_algorithm_logic("hba1c")
#' get_algorithm_logic("gld")
#' }
get_algorithm_logic <- function(criteria, algorithm = NULL) {
  checkmate::assert_character(criteria)
  if (!is.null(algorithm)) {
    checkmate::assert_list(algorithm)
  } else {
    algorithm <- algorithm()
  }

  algorithm[[criteria]]$logic |>
    stringr::str_replace_all("AND", "&") |>
    stringr::str_replace_all("OR", "|") |>
    stringr::str_replace_all("NOT", "!") |>
    # regex are defined with '=~', so convert them into a stringr function.
    stringr::str_replace_all(
      "([a-zA-Z0-9_]+) \\=\\~ '(.*?)'",
      "stringr::str_detect(\\1, '\\2')"
    )
}
