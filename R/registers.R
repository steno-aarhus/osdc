#’ Register variables (with descriptions) required for the
#' osdc algorithm.
#'
#' @returns Outputs a list of registers and variables required by osdc. Each
#'   list item contains the official Danish name of the register, the start
#'   year, the end year, and the variables with their descriptions. The
#'   variables item is a data frame with 4 columns:
#'
#'   \describe{
#'      \item{name}{The official name of the variable found in the register.}
#'      \item{danish_description}{The official Danish description of the variable.}
#'      \item{english_description}{The translated English description of the variable.}
#'      \item{data_type}{The data type, e.g. "character" of the variable. Could have multiple options (e.g. "Date" or "character").}
#'   }
#' @source Many of the details within the [registers()] metadata come
#'   from the full official list of registers from Statistics Denmark (DST):
#'   <https://www.dst.dk/extranet/forskningvariabellister/Oversigt%20over%20registre.html>
#' @export
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
        # Either a date or a character, we can format it to Date from character.
        "foed_dato", "Foedselsdato", "Date of birth", c("Date", "character")
      )
    ),
    lmdb = list(
      name = "Laegemiddelstatistikregisteret",
      start_year = 1995,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "pnr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "eksd", "Ekspeditionsdato", "Date of purchase", c("Date", "character"),
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
        "d_inddto", "Indlaeggelsesdato (start paa kontakt)", "Date of admission or initial contact", c("Date", "character"),
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
    kontakter = list(
      name = "Landspatientregisterets kontakttabel (LPR3)",
      start_year = 2019,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        # LPR3 equivalent to PNR in LPR2
        "cpr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        # LPR3 equivalent to RECNUM in LPR2
        "dw_ek_kontakt", "Kontakt id-nummer", "Record id number", "character",
        # LPR3 equivalent to D_INDDTO in LPR2
        "dato_start", "Indlaeggelsesdato (start paa kontakt)", "Date of admission or initial contact", c("Date", "character"),
        "hovedspeciale_ans", "Afdelings speciale", "Specialty of department", "character"
      )
    ),
    diagnoser = list(
      name = "Landspatientregisterets diagnosetabel (LPR3)",
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
        # Even though this is a "date", it is in a very odd format, so we want to
        # format it our way, just in case.
        "honuge", "Aar og uge for ydelse", "Year and week of service", "character"
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
        # Even though this is a "date", it is in a very odd format, so we want to
        # format it our way, just in case.
        "honuge", "Aar og uge for ydelse", "Year and week of service", "character"
      )
    ),
    lab_forsker = list(
      name = "Laboratoriedatabasens forskertabel",
      start_year = 2011,
      end_year = NA,
      variables = tibble::tribble(
        ~name, ~danish_description, ~english_description, ~data_type,
        "patient_cpr", "Pseudonymiseret cpr-nummer", "Pseudonymised social security number", "character",
        "samplingdate", "Dato for proevetagning", "Date of sampling", c("Date", "character"),
        "analysiscode", "Analysens NPU-kode", "NPU code of analysis", "character",
        "value", "Numerisk resultat af analyse", "Numerical result of analysis", "numeric"
      )
    )
  )
}
