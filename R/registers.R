#' Register variables (with descriptions) required for the osdc algorithm.
#'
#' @returns Outputs a list of registers and variables required by osdc. Each
#'   list item contains the official Danish name of the register, the start
#'   year, the end year, and the variables with their descriptions. Each
#'   register item is a list with 4 items:
#'
#'   \describe{
#'      \item{name}{The official name of the variable found in the register.}
#'      \item{danish_description}{The official Danish description of the variable.}
#'      \item{english_description}{The translated English description of the variable.}
#'      \item{data_type}{The data type, e.g. "character" of the variable.}
#'   }
#'
#' @source Many of the details within the [registers()] metadata come
#'   from the full official list of registers from Statistics Denmark (DST):
#'   <https://www.dst.dk/extranet/forskningvariabellister/Oversigt%20over%20registre.html>
#' @export
#' @examples
#' registers()
registers <- function() {
  list(
    bef = list(
      name = "CPR-registerets befolkningstabel",
      start_year = 1968,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "koen", "Koen", "Gender/sex", "integer",
        "foed_dato", "Foedselsdato", "Date of birth", "Date"
      )
    ),
    lmdb = list(
      name = "Laegemiddelstatistikregisteret",
      start_year = 1995,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "eksd", "Ekspeditionsdato", "Date of purchase", "Date",
        "atc", "ATC-kode (fuldt specificeret)", "ATC code (fully specified)", "character",
        "volume", "Antal standarddoser (DDD) i pakken", "Number of daily standard doses (DDD) in package", "numeric",
        "apk", "Antal pakker koebt", "Number of packages purchased", "numeric",
        "indo", "Indikationskode for recept", "Indication code", "character"
      )
    ),
    lpr_adm = list(
      name = "Landspatientregisterets administrationstabel (LPR2)",
      start_year = 1977,
      end_year = 2018,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "recnum", "Kontakt id-nummer", "Record id number", "character",
        "d_inddto", "Indlaeggelsesdato (start paa kontakt)", "Date of admission or initial contact", "Date",
        "c_spec", "Afdelings specialekode", "Specialty code of department", "character"
      )
    ),
    lpr_diag = list(
      name = "Landspatientregisterets diagnosetabel (LPR2)",
      start_year = 1977,
      end_year = 2018,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "recnum", "Kontakt id-nummer", "Record id number", "character",
        "c_diag", "Diagnosekode", "Diagnosis code", "character",
        "c_diagtype", "Diagnosetype", "Diagnosis type", "character",
      )
    ),
    lpr3a_kontakt = list(
      name = "Landspatientregisterets kontakttabel (LPR3A)",
      start_year = 2019,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer. Svarer til pnr i LPR2.", "Pseudonymised social security number. Equivalent to pnr in LPR2.", "character",
        "dw_ek_kontakt", "Kontakt id-nummer. Svarer til recnum i LPR2.", "Record id number. Equivalent to recnum in LPR2.", "character",
        "kont_starttidspunkt", "Indlaeggelsesdato (start paa kontakt). Svarer til d_inddto i LPR2.", "Date of admission or initial contact. Equivalent to d_inddto in LPR2.", c("POSIXct", "POSIXt"),
        "kont_ans_hovedspec", "Afdelings speciale. Ligner c_spec i LPR2, men indholdet er formatteret som tekststrenge.", "Specialty of department. Similar to c_spec in LPR2, but values are strings.", "character"
      )
    ),
    lpr3a_diagnose = list(
      name = "Landspatientregisterets diagnosetabel (LPR3A)",
      start_year = 2019,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "dw_ek_kontakt", "Kontakt id-nummer", "Record id number", "character",
        "diag_kode", "Diagnosekode. Svarer til c_diag i LPR2.", "Diagnosis code. Equivalent to c_diag in LPR2.", "character",
        "diag_type", "Diagnosetype. Svarer til c_diagtype i LPR2.", "Diagnosis type. Equivalent to c_diagtype in LPR2.", "character",
        "senere_afkraeftet", "Blev diagnosen senere afkraeftet?", "Was the diagnosis retracted later?", "character"
      )
    ),
    lpr3f_kontakter = list(
      name = "Landspatientregisterets kontakttabel (LPR3F)",
      start_year = 2019,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer. Svarer til pnr i LPR2.", "Pseudonymised social security number. Equivalent to pnr in LPR2.", "character",
        "dw_ek_kontakt", "Kontakt id-nummer. Svarer til recnum i LPR2.", "Record id number. Equivalent to recnum in LPR2.", "character",
        "dato_start", "Indlaeggelsesdato (start paa kontakt). Svarer til d_inddto i LPR2.", "Date of admission or initial contact. Equivalent to d_inddto in LPR2.", "Date",
        "hovedspeciale_ans", "Afdelings speciale", "Specialty of department", "character"
      )
    ),
    lpr3f_diagnoser = list(
      name = "Landspatientregisterets diagnosetabel (LPR3F)",
      start_year = 2019,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "dw_ek_kontakt", "Kontakt id-nummer", "Record id number", "character",
        "diagnosekode", "Diagnosekode", "Diagnosis code", "character",
        "diagnosetype", "Diagnosetype", "Diagnosis type", "character",
        "senere_afkraeftet", "Blev diagnosen senere afkraeftet?", "Was the diagnosis retracted later?", "character"
      )
    ),
    sysi = list(
      name = "Sygesikringsregisteret",
      start_year = 1990,
      end_year = 2005,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "barnmak", "Blev ydelse ydet til patientens barn?", "Was the service provided to the patient's child?", "integer",
        "speciale", "Ydelsens honoreringskode", "Billing code of the service (fully specified)", "character",
        "honuge", "Aar og uge for ydelse (ikke-standard datoformat)", "Year and week of service (non-standard date format)", "character"
      )
    ),
    sssy = list(
      name = "Sygesikringsregisteret",
      start_year = 2006,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "barnmak", "Blev ydelse ydet til patientens barn?", "Was the service provided to the patient's child?", "integer",
        "speciale", "Ydelsens honoreringskode", "Billing code of the service (fully specified)", "character",
        "honuge", "Aar og uge for ydelse (ikke-standard datoformat)", "Year and week of service (non-standard date format)", "character"
      )
    ),
    lab_forsker = list(
      name = "Laboratoriedatabasens forskertabel",
      start_year = 2011,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "samplingdate", "Dato for proevetagning", "Date of sampling", "Date",
        "analysiscode", "Analysens NPU-kode", "NPU code of analysis", "character",
        "value", "Numerisk resultat af analyse", "Numerical result of analysis", "numeric"
      )
    )
  )
}

#' Joined register variables required by [classify_diabetes()].
#'
#' @returns Outputs a list of registers and variables required by
#'   [classify_diabetes()]. Each list item contains the  Danish name of the
#'   register, the start year, the end year, and the variables with their
#'   descriptions. Each register item is a list with 4 items:
#'
#'   \describe{
#'      \item{name}{The name of the variable found in the register.}
#'      \item{danish_description}{The Danish description of the variable.}
#'      \item{english_description}{The translated English description of the variable.}
#'      \item{data_type}{The data type, e.g. "character" of the variable. Could have multiple options (e.g. "Date" or "character").}
#'   }
#'
#' @noRd
joined_registers <- function() {
  list(
    lpr = list(
      name = "Landspatientregisteret",
      start_year = NA,
      end_year = NA,
      # TODO: Add which variables all variables come from (LPR2, LPR3F, LPR3A).
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "date", "Dato for kontakt. Fra d_inddto i LPR2 (lpr_adm) og fra dato_start i LPR3F (lpr3f_kontakter).", "Contact date. From d_inddto in LPR2 (lpr_adm) and dato_start in LPR3F (lpr3f_kontakter).", "Date",
        "is_primary_diagnosis", "Er diagnosen en primaer diagnose?", "Is the diagnosis a primary diagnosis?", "logical",
        "is_diabetes_code", "Tilhoerer diagnosekoden diabetesdiagnoser?", "Does the diagnosis code belong to diabetes diagnoses?", "logical",
        "is_t1d_code", "Tilhoerer diagnosekoden type 1 diabetes?", "Does the diagnosis code belong to type 1 diabetes?", "logical",
        "is_t2d_code", "Tilhoerer diagnosekoden type 2 diabetes?", "Does the diagnosis code belong to type 2 diabetes?", "logical",
        "is_endocrinology_dept", "Tilhoerer kontakten en endokrinologisk afdeling?", "Does the concect belong to a endocrinology department?", "logical",
        "is_medical_dept", "Tilhoerer kontakten en medicinsk afdeling (ikke endokrinologi)?", "Does the diagnosis code belong to a medical department (other than endocrinology)?", "logical",
        "is_pregnancy_code", "Tilhoerer diagnosekoden graviditet?", "Does the diagnosis code belong to pregnancy?", "logical"
      )
    ),
    hsr = list(
      name = "Health services registers (SYSI and SSSY)",
      start_year = NA,
      end_year = NA,
      variables = registers()$sssy$variables
    )
  )
}
