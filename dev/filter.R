
# 0.0: Extracts the Data Needed to Generate the Diabetes Population -------

# Extracts the data needed for the algorithms (and a few extras) and puts it in the /data/source/ folder..
source(here::here("R/packages.R"))

# Create folders used by filter.R:
dir_create(here("data/source"))
dir_create(here("data/source/years"))


# 1.0: Clinical Laboratory Results --------

# 1.1: The Clinical Laboratory Information Systems (LABKA) --------
# Filter and append data from the Clinical Laboratory Information System (LABKA & Register of Laboratory Results for Research):


# Define file pattern and subfolder for intermediate year-files:
file_pattern <- "^labka"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)

dir_create(paste(here("data/source/years", substr(file_pattern, 2, 6) ) ) )

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
  saveRDS(dt, paste(here("data/source/years"), '/', substr(file_pattern, 2, 6), '/', filename, sep=''), compress = FALSE)
  remove(dt)
}

for (filename in raw_file_list) {
  filter_lab(filename)
}

# Open the filtered CLIS files for each year, append them and save as one:
lab_file_list_years <- list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 6), sep =''), full.names = TRUE, pattern = file_pattern)
labka <- rbindlist(lapply(lab_file_list_years, readRDS) )

# Recode and filter nonsensical result values:

# What analyses have relational operators, negative or num-numeric values:
summary(factor(labka[RELATIONSIGN != "="]$INTERNAL_REPLY_NUM))
summary(factor(labka[RELATIONSIGN != "="]$OL_INVER_IUPAC_CDE))
summary(factor(labka[INTERNAL_REPLY_NUM < 0]$OL_INVER_IUPAC_CDE))

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
rlrr <- readRDS(here("data", "raw", "lab_forsker.sas7bdat.rds"))

rlrr[, value_period := gsub(",", ".", VALUE)]

# What analyses have negative or num-numeric values:
summary(factor(rlrr[grep("^[1-9]|^0[.][0-9][0-9]", value_period, invert = T)]$value_period))

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

rm(labka, lab_data, rlrr)

saveRDS(hba1c, paste(here("data/source"),'/lab_hba1c.rds', sep=''), compress = FALSE)
saveRDS(cholesterol, paste(here("data/source"),'/lab_cholesterol.rds', sep=''), compress = FALSE)
saveRDS(kidney, paste(here("data/source"),'/lab_kidney.rds', sep=''), compress = FALSE)

rm(hba1c, cholesterol, kidney, lab_file_list_years, raw_file_list, file_pattern)


# 2.0: The Danish National Prescription Registry (LMDB) --------------------------------------------------------------------
# Filter and append data from The Danish National Prescription Registry (LMDB):

# Filter each year and save in /data/source/years/type for saving memory
# Antidiabetic drugs: ATC-codes A10:

# Define file pattern, ATC pattern and subfolder for intermediate year-files
file_pattern <- "^lmdb2|^lmdb199[7-9]"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)

meds_atc <- "^A10"
dir_create(paste(here("data/source/years", substr(meds_atc, 2, 4) ) ) )


filter_meds <- function(filename, meds_atc) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, EKSD, INDO, NAME, ATC, APK, VOLUME, PACKSIZE)]
  dt <- dt[!NAME == "Saxenda"]
  dt <- dt[grep(meds_atc, ATC)]
  saveRDS(dt, paste(here("data/source/years"), '/', substr(meds_atc, 2, 4), '/', filename, sep=''), compress = FALSE)
  remove(dt)
}

for (filename in raw_file_list) {
  filter_meds(filename, meds_atc)
}

# Open the filtered file for each year, append them and save as one:
# To-do for later: make list_year_files more flexible to include other data sources, move argument objects from globalEnv into functionEnv.
# Add rowbinding, keying and saving into list_year_files and add it to filter_xxx functions

list_year_files <-  function() {
  list.files(path = paste(here("data/source/years"), '/', substr(meds_atc, 2, 4), '/', sep=''), full.names = TRUE, pattern = file_pattern)
}
a10_file_list_years <-  list_year_files()
lmdb_a10 <- rbindlist(lapply(a10_file_list_years, readRDS) )
setkey(lmdb_a10, PNR, EKSD)
saveRDS(lmdb_a10, paste(here("data/source"),'/lmdb_a10.rds', sep=''), compress = FALSE)

rm(lmdb_a10, a10_file_list_years)




# Lipid-lowering drugs: ATC C10 (not necessary for generating the population, but is likely a relevant dataset for analyses):

# Define ATC pattern and subfolder for intermediate year-files
meds_atc <- "^C10"
dir_create(paste(here("data/source/years", substr(meds_atc, 2, 4) ) ) )

for (filename in raw_file_list) {
  filter_meds(filename, meds_atc)
}

c10_file_list_years <-  list_year_files()
lmdb_c10 <- rbindlist(lapply(c10_file_list_years, readRDS) )
setkey(lmdb_c10, PNR, EKSD)
saveRDS(lmdb_c10, paste(here("data/source"),'/lmdb_c10.rds', sep=''), compress = FALSE)

rm(lmdb_c10, c10_file_list_years, meds_atc, raw_file_list, file_pattern)


# 3.0: The Danish National Patient Registry (LPR) ---------------------------------------------------------------------
# Filter and append data from The Danish National Patient Registry (LPR):

# From ICD-10 onwards (1994).

# 3.1: Administrative data (lpr_adm) -------------------------------------------

# Define file pattern and subfolder for intermediate year-files:
file_pattern <- "^lpr_adm199[4-9]|^lpr_adm2|^uaf_adm"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)

dir_create(paste(here("data/source/years", substr(file_pattern, 2, 8) ) ) )


# Minimal filtering of lpr_adm (just check for columns) to merge with lpr_diag later:
# First step: filter each year into /source/years/
filter_lpr_adm <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, RECNUM, C_ADIAG, C_BLOK, C_SPEC, C_PATTYPE, D_INDDTO, D_UDDTO, V_ALDER)]
  saveRDS(dt, paste(here("data/source/years"), '/', substr(file_pattern, 2, 8), '/', filename, sep=''), compress = FALSE)
  remove(dt)
}

for (filename in raw_file_list) {
  filter_lpr_adm(filename)
}

# Open the filtered files for each year, append them and save as one:
adm_file_list_years <-  list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 8), sep =''), full.names = TRUE, pattern = file_pattern)
lpr_adm <- rbindlist(lapply(adm_file_list_years, readRDS) )
saveRDS(lpr_adm, paste(here("data/source"),'/years/lpr_adm_backup.rds', sep=''), compress = FALSE) # This save is just for protection against losing time in case of crashes

rm(adm_file_list_years, file_pattern, raw_file_list) # Keep lpr_adm for merging later

# 3.2: Additional diagnosis data (lpr_diag): -----------------------------------------------

# Import lpr_diag (data on A & B diagnoses) for merging with lpr_adm (to provide administrative data) later.


# Define file pattern and subfolder for intermediate year-files:
file_pattern <- "^lpr_diag199[4-9]|^lpr_diag2|^uaf_diag"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)
dir_create(paste(here("data/source/years", substr(file_pattern, 2, 9) ) ) )


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
  saveRDS(dt_comb,
          paste(
            here("data/source/years"),
            '/',
            substr(file_pattern, 2, 9),
            '/',
            filename,
            sep = ''
          ),
          compress = FALSE)
  remove(dt_dm, dt_preg, dt_gdm, dt_comb)
}

for (filename in raw_file_list) {
  filter_lpr_diag(filename)
}


# Open the filtered files for each year, append them and save as one complete file:
diag_file_list_years <-  list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 9), sep =''), full.names = TRUE, pattern = file_pattern)
lpr_diag <- rbindlist(lapply(diag_file_list_years, readRDS) )
saveRDS(lpr_diag, paste(here("data/source"),'/years/lpr_diag_backup.rds', sep=''), compress = FALSE) # This save is just for protection against losing time in case of crashes

rm(diag_file_list_years, file_pattern, raw_file_list) # Keep lpr_diag for merging in the following:


## Merge A + B-diagnoses from lpr_diag to administrative data in lpr_adm

lpr_comb <- merge(lpr_diag, lpr_adm, by = c("RECNUM", "PNR"), all = TRUE)
rm(lpr_adm, lpr_diag)
setkey(lpr_comb, PNR, D_INDDTO)

# Split into files based on diagnoses of interest:
lpr_dm <- lpr_comb[grep("^DE1[0-4]", C_DIAG)]
lpr_preg <- lpr_comb[grep("^DO[0-9]|^DZ3[2-7]", C_DIAG)]
lpr_gdm <- lpr_preg[grep("^DO244", C_DIAG)]

saveRDS(lpr_dm, paste(here("data/source"),'/lpr_dm.rds', sep=''), compress = FALSE)
saveRDS(lpr_preg, paste(here("data/source"),'/lpr_preg.rds', sep=''), compress = FALSE)
saveRDS(lpr_gdm, paste(here("data/source"),'/lpr_gdm.rds', sep=''), compress = FALSE)

rm(lpr_comb,lpr_dm, lpr_preg, lpr_gdm)

# 4.0: The Danish National Health Service Register (SSR) --------
# Filter and append data from The Danish National Health Service Register (SSR):

# For SSR subtable SSSY (year 2006 onwards):

# Define file pattern and subfolder for intermediate year-files:
file_pattern <- "^sssy"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)
dir_create(paste(here("data/source/years", substr(file_pattern, 2, 5) ) ) )


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

  saveRDS(dt_comb, paste(here("data/source/years"), '/', substr(file_pattern, 2, 5), '/', filename, sep=''), compress = FALSE)
  remove(dt_comb)
}

for (filename in raw_file_list) {
  filter_ssr(filename)
}


# Open the filtered files for each year, append them and save as one complete file:
sssy_file_list_years <-  list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 5), sep =''), full.names = TRUE, pattern = file_pattern)
sssy <- rbindlist(lapply(sssy_file_list_years, readRDS) )
saveRDS(sssy, paste(here("data/source"),'/years/sssy_backup.rds', sep=''), compress = FALSE) # This save is just for protection against losing time in case of crashes

rm(sssy_file_list_years, file_pattern, raw_file_list) # Keep sssy for merging in the following:


# For SSR subtable SYSI (years 1990 - 2005)

file_pattern <- "^sysi"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)
dir_create(paste(here("data/source/years", substr(file_pattern, 2, 5) ) ) )

for (filename in raw_file_list) {
  filter_ssr(filename)
}

# Open the filtered files for each year, append them and save as one complete file:
sysi_file_list_years <-  list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 5), sep =''), full.names = TRUE, pattern = file_pattern)
sysi <- rbindlist(lapply(sysi_file_list_years, readRDS) )
saveRDS(sysi, paste(here("data/source"),'/years/sysi_backup.rds', sep=''), compress = FALSE) # This save is just for protection against losing time in case of crashes

rm(sysi_file_list_years, file_pattern, raw_file_list) # Keep sssy for merging in the following:


# Combine SSSY & SYSI and save to source folder:
ssr <- rbind(sssy, sysi)
setkey(ssr, PNR, REGDATE)
ssr_hba1c <- ssr[grep("7403$", SPECIALE)] # Not for inclusion
foot <- ssr[grep("^54", SPECIALE)]
eye <- ssr[grep("19011[1-2]| 193501| 193601| 196429", SPECIALE)] # Not for inclusion

saveRDS(ssr_hba1c, paste(here("data/source"),'/ssr_hba1c.rds', sep=''), compress = FALSE)
saveRDS(foot, paste(here("data/source"),'/ssr_foot.rds', sep=''), compress = FALSE)
saveRDS(eye, paste(here("data/source"),'/ssr_eye.rds', sep=''), compress = FALSE)

rm(ssr, foot, eye)


# 5.0: The Civil Registration System (CPR) -------------------------------------

# Gather date-of-birth & sex variables (and origin since it is also time-independent) for the population through time with the population table "bef":

file_pattern <- "^bef"
raw_file_list <-  list.files(path = here("data/raw/"), pattern = file_pattern)

dir_create(paste(here("data/source/years", substr(file_pattern, 2, 4) ) ) )

import_bef <- function(filename) {
  dt <- as.data.table(readRDS(paste(here("data/raw/"), '/', filename, sep='') ) )
  names(dt) <- toupper(names(dt))
  dt <- dt[, .(PNR, KOEN, FOED_DAG)]
  saveRDS(dt, paste(here("data/source/years"), '/', substr(file_pattern, 2, 4), '/', filename, sep=''), compress = FALSE)
  remove(dt)
}

for (filename in raw_file_list) {
  import_bef(filename)
}

# Open the filtered files for each year, append them and save as one:
bef_file_list_years <- list.files(path = paste(here("data/source/years"), '/', substr(file_pattern, 2, 4), sep =''), full.names = TRUE, pattern = file_pattern)
bef_alltime <- rbindlist(lapply(bef_file_list_years, readRDS) )
bef_alltime <- unique(bef_alltime, by = "PNR")

saveRDS(bef_alltime, paste(here("data/source"),'/bef_alltime.rds', sep=''), compress = FALSE)
