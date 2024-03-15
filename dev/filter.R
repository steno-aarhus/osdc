
# 1.0: Clinical Laboratory Results --------

# 1.1: The Clinical Laboratory Information Systems (LABKA) --------
# Filter and append data from the Clinical Laboratory Information System (LABKA & Register of Laboratory Results for Research):

# First step: filter each part/year into /source/years/
filter_lab <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, REALSAMPLECOLLECTIONTIME, OL_INVER_IUPAC_CDE, RELATIONSIGN, INTERNAL_REPLY_NUM)]
  dt <- dt[OL_INVER_IUPAC_CDE %in% c('NPU27300',
                                     'NPU03835',
                                     'NPU01566',
                                     'NPU01567',
                                     'NPU01568',
                                     'NPU10171',
                                     'NPU19661',
                                     'NPU18016',
                                     'DNK35302'
  )
  ]
  remove(dt)
}

labka[, INTERNAL_REPLY_NUM :=
       ifelse(
         RELATIONSIGN == "=",  INTERNAL_REPLY_NUM,
         ifelse(RELATIONSIGN == "<" | RELATIONSIGN == "<=", INTERNAL_REPLY_NUM - 0.01,
                ifelse(RELATIONSIGN == ">" | RELATIONSIGN == ">=", INTERNAL_REPLY_NUM + 0.01, NA)
         )
       )
       ]

# 1.2: The Register of Laboratory Results for Research (RLRR) --------
# Recode and filter nonsensical result values and append the analyses to the CLIS files above:

rlrr[, value_period := gsub(",", ".", VALUE)]

# Recode results with relational operators and format result as numeric:

rlrr[, INTERNAL_REPLY_NUM :=
       ifelse(
         grepl("^<", value_period),
         as.numeric(sub("^.", "", value_period)) - 0.01,
         ifelse(
           grepl("^<=", value_period),
           as.numeric(sub("^..", "", value_period)) - 0.01,
           ifelse(
             grepl("^>", value_period),
             as.numeric(sub("^.", "", value_period)) + 0.01,
             ifelse(
               grepl("^>=", value_period),
               as.numeric(sub("^..", "", value_period)) + 0.01,
               as.numeric(value_period)
             )
           )
         )
       )]

# Combine the two lab data sources:

lab_data <- rbind(labka[!is.na(INTERNAL_REPLY_NUM),
                        .(
                          PNR,
                          REALSAMPLECOLLECTIONTIME = as.Date(REALSAMPLECOLLECTIONTIME),
                          OL_INVER_IUPAC_CDE,
                          INTERNAL_REPLY_NUM
                        )],
                  rlrr[!is.na(INTERNAL_REPLY_NUM),
                       .(
                         PNR = PATIENT_CPR,
                         REALSAMPLECOLLECTIONTIME = SAMPLINGDATE,
                         OL_INVER_IUPAC_CDE = ANALYSISCODE,
                         INTERNAL_REPLY_NUM
                       )])

lab_data <- lab_data[INTERNAL_REPLY_NUM > 0]

# Sort and filter out duplicates (same person, analysis and date: use only the first row each day):
setkey(lab_data, PNR, REALSAMPLECOLLECTIONTIME)


#lab_data[duplicated(lab_data, by = c("PNR","OL_INVER_IUPAC_CDE", "REALSAMPLECOLLECTIONTIME"))]
#View(lab_data[PNR %in% lab_data[duplicated(lab_data, by = c("PNR","OL_INVER_IUPAC_CDE", "REALSAMPLECOLLECTIONTIME"))]$PNR])

lab_data <- lab_data[!duplicated(lab_data, by = c("PNR","OL_INVER_IUPAC_CDE", "REALSAMPLECOLLECTIONTIME"))]

hba1c <- lab_data[OL_INVER_IUPAC_CDE %in% c('NPU27300', # HbA1c IFCC
                                         'NPU03835') # HbA1c DCCT
]
hba1c[OL_INVER_IUPAC_CDE == "NPU03835", INTERNAL_REPLY_NUM := (INTERNAL_REPLY_NUM*100*10.93)-23.5] # Convert DCCT to IFCC units

cholesterol <- lab_data[OL_INVER_IUPAC_CDE %in% c('NPU01566', # total P-cholesterol
                                               'NPU01567', # P-HDL cholesterol
                                               'NPU01568', # P-LDL cholesterol
                                               'NPU10171') # P-LDL cholesterol (fasting sample)
]
kidney <- lab_data[OL_INVER_IUPAC_CDE %in% c('NPU19661', # U-albumine/creatinine ratio
                                          'NPU18016', # P-creatinine
                                          'DNK35302') # eGFR (lab-computed based on P-creatinine, sex and age) as ml/min/1,73 m^2 body surface area
]

# 2.0: The Danish National Prescription Registry (LMDB) --------------------------------------------------------------------
# Filter and append data from The Danish National Prescription Registry (LMDB):

# Filter each year and save in /data/source/years/type for saving memory
# Antidiabetic drugs: ATC-codes A10:

meds_atc <- "^A10"

filter_meds <- function(filename, meds_atc) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, EKSD, INDO, NAME, ATC, APK, VOLUME, PACKSIZE)]
  dt <- dt[!NAME == "Saxenda"]
  dt <- dt[grep(meds_atc, ATC)]
  remove(dt)
}

# Open the filtered file for each year, append them and save as one:
# To-do for later: make list_year_files more flexible to include other data sources, move argument objects from globalEnv into functionEnv.
# Add rowbinding, keying and saving into list_year_files and add it to filter_xxx functions

lmdb_a10 <- rbindlist(lapply(a10_file_list_years, readRDS) )
setkey(lmdb_a10, PNR, EKSD)

# Lipid-lowering drugs: ATC C10 (not necessary for generating the population, but is likely a relevant dataset for analyses):

# Define ATC pattern and subfolder for intermediate year-files
meds_atc <- "^C10"

# 3.0: The Danish National Patient Registry (LPR) ---------------------------------------------------------------------
# Filter and append data from The Danish National Patient Registry (LPR):

# From ICD-10 onwards (1994).

# 3.1: Administrative data (lpr_adm) -------------------------------------------

# Minimal filtering of lpr_adm (just check for columns) to merge with lpr_diag later:
# First step: filter each year into /source/years/
filter_lpr_adm <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, RECNUM, C_ADIAG, C_BLOK, C_SPEC, C_PATTYPE, D_INDDTO, D_UDDTO, V_ALDER)]
  remove(dt)
}

# 3.2: Additional diagnosis data (lpr_diag): -----------------------------------------------

# Import lpr_diag (data on A & B diagnoses) for merging with lpr_adm (to provide administrative data) later.

filter_lpr_diag <- function(filename) {
  dt <-
    as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep = '')))
  names(dt) <- toupper(names(dt))
  if ("C_TILDIAG" %in% names(dt)) {
    dt <- dt[, .(PNR, RECNUM, C_DIAG, C_DIAGTYPE, C_TILDIAG)]
  } else {
    dt <- dt[, .(PNR, RECNUM, C_DIAG, C_DIAGTYPE)]
  }
  dt_dm <-
    dt[C_DIAGTYPE %in% c("A", "B") & grepl("^DE1[0-4]", C_DIAG)]
  dt_preg <- dt[grep("^DO[0-9]|^DZ3[2-7]", C_DIAG)]
  dt_gdm <- dt_preg[grep("^DO244", C_DIAG)]
  dt_comb <- rbindlist(list(dt_dm,
                            dt_preg,
                            dt_gdm))

}

## Merge A + B-diagnoses from lpr_diag to administrative data in lpr_adm

lpr_comb <- merge(lpr_diag, lpr_adm, by = c("RECNUM", "PNR"), all = TRUE)
setkey(lpr_comb, PNR, D_INDDTO)

# Split into files based on diagnoses of interest:
lpr_dm <- lpr_comb[grep("^DE1[0-4]", C_DIAG)]
lpr_preg <- lpr_comb[grep("^DO[0-9]|^DZ3[2-7]", C_DIAG)]
lpr_gdm <- lpr_preg[grep("^DO244", C_DIAG)]

# 4.0: The Danish National Health Service Register (SSR) --------
# Filter and append data from The Danish National Health Service Register (SSR):

# For SSR subtable SSSY (year 2006 onwards):

filter_ssr <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[ BARNMAK == "0", .(PNR, BARNMAK, HONUGE, SPECIALE)]

  # Reformat the date structure to something useful (the first day of the week of the registration):
  dt[, YEAR := paste(
    ifelse(
      grepl("^9", HONUGE), paste("19", sub("..$","",HONUGE), sep = ""),
      paste("20", sub("..$","",HONUGE), sep = "")))]
  dt[, WEEK := paste(
    "W", sub("^..", "", HONUGE), sep = "")]
  dt[, REGDATE := ISOweek2date(
    paste(
      YEAR, WEEK, 1, sep = "-")
  )]
  dt <- dt[, .(PNR, REGDATE, SPECIALE)]
  # Filter codes:
  dt_comb <- dt[grep("7403$|^54|19011[1-2]| 193501| 193601| 196429", SPECIALE)]

}

# For SSR subtable SYSI (years 1990 - 2005)

# Combine SSSY & SYSI and save to source folder:
ssr <- rbind(sssy, sysi)
setkey(ssr, PNR, REGDATE)
ssr_hba1c <- ssr[grep("7403$", SPECIALE)] # Not for inclusion
foot <- ssr[grep("^54", SPECIALE)]
eye <- ssr[grep("19011[1-2]| 193501| 193601| 196429", SPECIALE)] # Not for inclusion

# 5.0: The Civil Registration System (CPR) -------------------------------------

import_bef <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, KOEN, FOED_DAG)]
}
