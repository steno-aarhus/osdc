#' A list of the algorithmic logic underlying osdc.
#'
#' This nested list contains the logic details of the algorithm.
#'
#' @format
#' Is a list with nested lists that have these named elements:
#'
#' \describe{
#'  \item{register}{Optional. The register used for this logic}
#'  \item{title}{The title to use when displaying the logic in tables.}
#'  \item{logic}{The logic itself.}
#'  \item{comments}{Some additional comments on the logic.}
#' }
#'
#' @returns A nested list with the algorithmic logic. Contains
#'   fields `register`, `title`, `logic`, and `comments`.
#' @export
#'
#' @seealso See the `vignette("algorithm")` for the logic used to filter these
#'   patients.
#' @examples
#' algorithm()$is_hba1c_over_threshold
#' algorithm()$is_gld_code$logic
algorithm <- function() {
  list(
    is_hba1c_over_threshold = list(
      register = "lab_forsker",
      title = "HbA1c values over threshold",
      logic = "(analysiscode == 'NPU27300' AND value >= 48) OR (analysiscode == 'NPU03835' AND value >= 6.5)",
      comments = "Is the IFCC units for NPU27300 and DCCT units for NPU03835."
    ),
    is_gld_code = list(
      register = "lmdb",
      title = "ATC codes for glucose-lowering drugs (GLDs)",
      logic = "atc =~ '^A10' AND NOT (atc =~ '^(A10BJ|A10BK01|A10BK03)')",
      comments = "GLP-RAs or dapagliflozin/empagliflozin drugs are not kept."
    ),
    is_non_insulin_gld_code = list(
      register = "lmdb",
      title = "Non-insulin glucose-lowering drugs",
      logic = "atc =~ '^A10B' OR atc =~ '^A10AE56'",
      comments = "This is used during the classification of type 1 diabetes to identify persons who only purchase insulin or mostly purchase insulin."
    ),
    is_insulin_gld_code = list(
      register = "lmdb",
      title = "Only insulin glucose-lowering drugs",
      logic = "atc =~ '^A10A' AND NOT (atc =~ '^A10AE56')",
      comments = "This is used during the classification of type 1 diabetes to identify persons who only purchase insulin or mostly purchase insulin."
    ),
    lpr2_is_needed_code = list(
      register = "lpr_diag",
      title = "LPR2 codes used throughout the algorithm",
      logic = "c_diag =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37]|DE1[0-4]|249|250)' AND (c_diagtype == 'A' OR c_diagtype == 'B')",
      comments = "A `c_diagtype` of` 'A'` means primary diagnosis, while 'B' means secondary diagnosis. "
    ),
    lpr2_is_diabetes_code = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for any diabetes",
      logic = "c_diag =~ '^(DE1[0-4]|249|250)'",
      comments = ""
    ),
    lpr2_is_t1d_code = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for T1D",
      logic = "c_diag =~ '^(DE10|249)'",
      comments = ""
    ),
    lpr2_is_t2d_code = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for T2D",
      logic = "c_diag =~ '^(DE11|250)'",
      comments = ""
    ),
    lpr2_is_endocrinology_dept = list(
      register = "lpr_adm",
      title = "LPR2 endocrinology department",
      logic = "c_spec == 8",
      comments = "`TRUE` when the department where the recorded diagnosis was endocrinology."
    ),
    lpr2_is_medical_dept = list(
      register = "lpr_adm",
      title = "LPR2 other medical department",
      logic = "c_spec %in% c(1:7, 9:30)",
      comments = "`TRUE` when the diagnosis was recorded at a medical department other than endocrinology."
    ),
    lpr2_is_pregnancy_code = list(
      register = "lpr_diag",
      title = "LPR2 diagnoses codes for pregnancy-related outcomes",
      logic = "c_diag =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37])'",
      comments = "These are recorded pregnancy endings like live births and miscarriages."
    ),
    lpr2_is_primary_dx = list(
      register = "lpr_diag",
      title = "LPR2 primary diagnosis",
      logic = "c_diagtype == 'A'",
      comments = ""
    ),
    lpr3_is_endocrinology_dept = list(
      register = "kontakter",
      title = "LPR3 endocrinology department",
      logic = "hovedspeciale_ans  == 'medicinsk endokrinologi'",
      comments = "`TRUE` when the department is endocrinology."
    ),
    lpr3_is_medical_dept = list(
      register = "kontakter",
      title = "LPR3 medical department",
      # TODO: We will need to make sure the Unicode character gets selected properly in real data.
      logic = "hovedspeciale_ans %in% c('blandet medicin og kirurgi', 'intern medicin', 'geriatri', 'hepatologi', 'h\u00e6matologi', 'infektionsmedicin', 'kardiologi', 'medicinsk allergologi', 'medicinsk gastroenterologi', 'medicinsk lungesygdomme', 'nefrologi', 'reumatologi', 'palliativ medicin', 'akut medicin', 'dermato-venerologi', 'neurologi', 'onkologi', 'fysiurgi', 'tropemedicin')",
      comments = "`TRUE` when the department is other medical departments (than endocrinology)."
    ),
    lpr3_is_needed_code = list(
      register = "diagnoser",
      title = "LPR3 codes used throughout the algorithm",
      logic = "diagnosekode =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37]|DE1[0-4])' AND (diagnosetype == 'A' OR diagnosetype == 'B') AND (senere_afkraeftet == 'Nej')",
      comments = "`A` `diagnosekode` means primary diagnosis and `senere_afkraeftet` means diagnosis was later retracted."
    ),
    lpr3_is_primary_dx = list(
      register = "diagnoser",
      title = "LPR3 primary diagnosis",
      logic = "diagnosetype == 'A'",
      comments = ""
    ),
    lpr3_is_t1d_code = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for T1D",
      logic = "diagnosekode =~ '^(DE10)'",
      comments = ""
    ),
    lpr3_is_t2d_code = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for T2D",
      logic = "diagnosekode =~ '^(DE11)'",
      comments = ""
    ),
    lpr3_is_diabetes_code = list(
      register = "diagnoser",
      title = "LPR3 diagnoses codes for diabetes",
      logic = "diagnosekode =~ '^DE1[0-4]'",
      comments = "This is a general diabetes code, not specific to T1D or T2D."
    ),
    lpr3_is_pregnancy_code = list(
      register = "diagnoser",
      title = "ICD-10 diagnoses codes for pregnancy-related outcomes",
      logic = "diagnosekode =~ '^(DO0[0-6]|DO8[0-4]|DZ3[37])'",
      comments = "These are recorded pregnancy endings like live births and miscarriages."
    ),
    is_not_within_pregnancy_interval = list(
      register = NA,
      title = "Events that are not within a potential pregnancy interval",
      logic = "NOT (has_pregnancy_event AND date >= (pregnancy_event_date - weeks(40)) AND date <= (pregnancy_event_date + weeks(12))) OR is.na(pregnancy_event_date)",
      comments = "The potential pregnancy interval is defined as 40 weeks before and 12 weeks after the pregnancy event date."
    ),
    is_podiatrist_services = list(
      register = NA,
      title = "Podiatrist services",
      logic = "speciale =~ '^54' AND barnmak == 0",
      comments = "When `barnmak == 0`, the PNR belongs to the recipient of the service. When `barnmak == 1`, the PNR belongs to the child of the individual."
    ),
    is_not_metformin_for_pcos = list(
      register = NA,
      title = "Metformin purchases that aren't potentially for the treatment of PCOS",
      logic = "NOT (koen == 2 AND atc =~ '^A10BA02$' AND ((date - foed_dato) < years(40) OR indication_code %in% c('0000092', '0000276', '0000781')))",
      comments = "Woman is defined as 2 in `koen`."
    ),
    is_any_t1d_primary_diagnosis = list(
      register = NA,
      title = "Any primary diagnosis for type 1 diabetes",
      logic = "(n_t1d_endocrinology + n_t1d_medical) >= 1",
      comments = "This is used to classify type 1 diabetes."
    ),
    is_endocrinology_dx = list(
      register = NA,
      title = "Diagnosis of diabetes from an endocrinology department",
      logic = "n_t1d_is_endocrinology_dept AND (is_t1d_code OR is_t2d_code)",
      comments = "This is used to classify type 1 diabetes."
    ),
    insulin_purchases_within_180_days = list(
      register = NA,
      title = "Any insulin purchases within 180 days",
      # Any purchase of insulin within 180 days of the first purchase of a glucose-lowering drug.
      logic = "is_insulin_gld_code & date <= (first_gld_date + days(180))",
      comments = "This is used to classify type 1 diabetes."
    ),
    t1d = list(
      register = NA,
      title = "Classifying type 1 diabetes status",
      logic = "(only_insulin_purchases & is_any_t1d_primary_diagnosis) | (!only_insulin_purchases & is_any_t1d_primary_diagnosis & is_majority_dx & is_two_thirds_insulin & insulin_purchases_within_180_days)",
      comments = "The final classification for type 1 diabetes. Depends on all the previous steps to create these intermediate logical variables."
    )
  )
}

#' Get the algorithmic logic and convert to an R logic condition.
#'
#' @param logic_name The name of the logic to use.
#' @param algorithm The list of algorithmic logic, one list for each.
#'
#' @return A character string.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_algorithm_logic("hba1c")
#' get_algorithm_logic("gld")
#' }
get_algorithm_logic <- function(logic_name, algorithm = NULL) {
  checkmate::assert_character(logic_name)
  if (!is.null(algorithm)) {
    checkmate::assert_list(algorithm)
  } else {
    algorithm <- algorithm()
  }

  algorithm[[logic_name]]$logic |>
    stringr::str_replace_all("AND", "&") |>
    stringr::str_replace_all("OR", "|") |>
    stringr::str_replace_all("NOT", "!") |>
    # regex are defined with '=~', so convert them into a stringr function.
    stringr::str_replace_all(
      "([a-zA-Z0-9_]+) \\=\\~ '(.*?)'",
      "stringr::str_detect(\\1, '\\2')"
    )
}
