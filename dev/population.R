
# 0.0.0: Generates the Diabetes Population --------------------------------

# 1.0.0: Definitions of Exclusion Variables -----------------------------------------

# 1.1.0: Gestational Diabetes Mellitus (GDM) Censoring Variable -------------------------------------------

# Used to censor laboratory results and reimbursed medication prescriptions to account for events possibly due to GDM:
# Inclusion events are censored during periods of pregnancy (with 12 weeks added to accound for delays in registrations):

# From 40 weeks before until 12 weeks after a registration of a pregnancy ending (due to birth, abortion or other causes)

# In addition, if a maternity care contact is registered, and there is no registration of a pregnancy ending in the
# 12 weeks preceding the contact or in the 40 weeks following it, inclusion events are censored:
# From 40 weeks before until 40 weeks after the maternity care contact.
# Subsequent maternity care contacts in the 28 weeks following such a maternity care contact are ignored (it's the same pregnancy)
# and do not create new windows of censoring.

# In other words, inclusion events are censored:
# Within [-40; 12] weeks from a birth, abortion or other cause of termination of pregnancy.
# Within [-40; 40] weeks from the first maternity care visit (in Denmark usually not prior to week 12 in a pregnancy: 28 weeks from week 12 through 40 of pregnancy + 12 weeks added for delays = 40 weeks) in a pregnancy with no ending registered in relation to it.



# 1.1.1 Create Pregnancy Dates -------------------------------------------------

# Load pregnancy data:

# Split dataset into days of pregnancy endings and days of maternity care visits:
preg_end <- lpr_all_preg[grep('^DO0[0-6]|^DO8[0-4]|^DZ3[37]', C_DIAG), .(PNR, C_DIAG, C_DIAGTYPE, D_INDDTO, D_UDDTO)][!is.na(D_INDDTO)]
setkey(preg_end, PNR, D_INDDTO)
preg_end <- unique(preg_end, by = c('PNR', 'D_INDDTO')) # Filter to one event per day per person

preg_visits <- lpr_all_preg[grep('^DO07|^DO[1-4]|^DZ3[2456]', C_DIAG), .(PNR, C_DIAG, C_DIAGTYPE, D_INDDTO, D_UDDTO)][!is.na(D_INDDTO)]
setkey(preg_visits, PNR, D_INDDTO)
preg_visits <- unique(preg_visits, by = c('PNR', 'D_INDDTO'))

# Discard all maternity care contacts within a period of 40 weeks before until 12 weeks after a pregnancy ending:
# Merge pregnancy endings to maternity care contacts (cartesian join, memory beware):
preg_visits_merged <- merge(preg_visits[, .(PNR, D_VISIT = D_INDDTO)], preg_end[, .(PNR, D_PREG_END = D_INDDTO)], by = 'PNR', all.y = FALSE, allow.cartesian = T)

# First, identify dates of maternity care visits with a related pregnancy ending:
preg_visits_merged[, WITH_END := D_VISIT > (D_PREG_END - (40*7)) & D_VISIT < (D_PREG_END + (12*7))]
preg_visits_with_end <- preg_visits_merged[WITH_END == T, .SD[1], by = .(PNR, D_VISIT)]

# Merge these dates to all maternity care visit dates, and filter all maternity care visits to only those without a related pregnancy ending:
preg_visits_no_end <- merge(preg_visits[, .(PNR, D_VISIT = D_INDDTO)],
                          preg_visits_with_end,
                          by = c('PNR', 'D_VISIT'),
                          all.x = T)[is.na(WITH_END), .(PNR, D_VISIT)]

# Remove 'duplicate' visits within a 28 week window of the first date of a maternity care visit:
create_window <- function(variable, interval) {
  n <- 1
  N <- length(variable)
  res <- rep(T, N)
  start <- variable[n]
  while (n < N) {
    ifelse(
      as.numeric(variable[n+1] - start) > interval, {
        res[n+1] <- T
        n <- n+1
        start <- variable[n]
      },
      {
        res[n+1] <- F
        n <- n+1
      }
    )
  }
  return(res)
}

preg_visits_no_end[, UNIQUE := create_window(D_VISIT, (28*7)), by = PNR]


# Create and save clean dataset with dates of pregnancy endings and maternity care contacts for use in censoring lab results and prescriptions for GDM:

pregnancy_dates <- rbind(preg_end[, .(PNR, D_VISIT = D_INDDTO, TYPE = 'END')], # Afslutninger
                      preg_visits_no_end[UNIQUE == T, .(PNR, D_VISIT, TYPE = 'VISIT')]) # Kontrol uden afslutning

# Is also used for later validation of GDM-diagnoses when creating a GDM cohort for research project with Anne Bo.

# 1.2.0: Polycystic Ovary Syndrome (PCOS) Censoring Variable ----------------

# Used to censor prescriptions of metformine potentially due to PCOS:
# All prescriptions of metformine reimbursed by women before their 40th birthday,
# and prescriptions of metformine with any of the following indication codes:
# - 0000092: 'mod hormonforstyrrelse'
# - 0000276: 'ved hormonforstyrrelse'
# - 0000781: 'forebyggende ved poly cystisk ovarie syndrom (PCOS)'

# The cut-off for age is arbitrary, but in line with the approach in other registers:
# both the 'old' and 'new' national diabetes registers by Carstensen et al. use an identical cut-off,
# but do not take indication codes into account.

# Even with HbA1c as a 'backup' to include women under 40 years of age on metformine monotherapy,
# we still see a spike in inclusion of women at age 40.
# These are presumably women with good glycemic control of diabetes on metformine alone or in treatment of PCOS above age 40.


# 1.2.1: Create PCOS Censoring Variable ---------------------------------------------

# The PCOS censoring variable is based on date of birth and sex.
# These variables are gathered for the whole population in the bef_alltime object, which was created during
# filtering of The Civil Registration System in filter.R


# 2.0.0: Inclusion Event Dates -------------------------------------



# 2.1.0: Inclusion Events from Laboratory Data ------------------------------


# 2.1.1: Load HbA1c Data and Filter to Positive Results -------------------



# Load HbA1c data and filter to only values diagnostic of diabetes (positive results):

hba1c_pos <- hba1c[INTERNAL_REPLY_NUM >= 48]



# 2.1.2: Censor HbA1c for GDM -----------------------------------

# Within [-40; 12] weeks from a birth, abortion or other cause of termination of pregnancy.
# Within [-40; 40] weeks from the first maternity care visit in a pregnancy with no ending registered in relation to it.

# Load pregnancy data:

# Merge with the dates of positive HbA1c results (cartesian join, memory beware):
hba1c_pos_pregnancies <- merge(hba1c_pos[,.(PNR, REALSAMPLECOLLECTIONTIME)], pregnancy_dates, by = 'PNR', all.x = TRUE, allow.cartesian = TRUE)

# Create censoring variable:
hba1c_pos_pregnancies[, GDM_CENSOR_SAMPLE :=
                         (TYPE == 'END'
                          # Within [-40; 12] weeks of a pregnancy ending.
                          & (as.Date(REALSAMPLECOLLECTIONTIME) < (D_VISIT + (12*7))
                             & as.Date(REALSAMPLECOLLECTIONTIME) > (D_VISIT - (40*7))))
                       |
                         (TYPE =='VISIT'
                          # Maternity care contacts are presumed to primarily take place in the last 28 weeks of a pregnancy,
                          # with 12 weeks added to account for potential registration delays,
                          # thus censoring within [-40; 28 + 12 = 40] weeks of a maternity contact (in absence of a related ending):
                          & (as.Date(REALSAMPLECOLLECTIONTIME) < (D_VISIT + (40*7))
                             & as.Date(REALSAMPLECOLLECTIONTIME) > (D_VISIT - (40*7))))
                       ]


# Reduce the dataset from the bloated cartesian join.
# Remove recycled HbA1c values due to multiple pregnancy dates from the same person:
hba1c_pos_pregnancies <- hba1c_pos_pregnancies[GDM_CENSOR_SAMPLE == TRUE,.SD[1], by = .(PNR, REALSAMPLECOLLECTIONTIME)]

# Merge the censoring variable onto the HbA1c dataset:
hba1c_pos_censor_gdm <- merge(hba1c_pos,
                              hba1c_pos_pregnancies,
                              by = c('PNR','REALSAMPLECOLLECTIONTIME'),
                              all.x = TRUE)

# Set NA's (persons with a positive HbA1c result, but no pregnancy dates) to FALSE:
hba1c_pos_censor_gdm[, GDM_CENSOR_SAMPLE := ifelse(is.na(GDM_CENSOR_SAMPLE), FALSE, TRUE)]

# Count how many individuals have a censored hba1c inclusion event due to possible gdm:
n_censored_events_hba1c_gdm <- nrow(hba1c_pos_censor_gdm[GDM_CENSOR_SAMPLE == T, .SD[1], by = PNR])

# Finally, exclude positive HbA1c results potentially due to GDM:
hba1c_pos_censor_gdm <- hba1c_pos_censor_gdm[GDM_CENSOR_SAMPLE == FALSE]
setkey(hba1c_pos_censor_gdm, PNR, REALSAMPLECOLLECTIONTIME)



# 2.1.3: HbA1c Inclusion Variables ----------------------------------------

# Create the final HbA1c inclusion events for each individual:

# Date of first blood sample of HbA1c >=48 mmol/mol:
do_pos_hba1c_1 <- hba1c_pos_censor_gdm[, .SD[1], by = PNR]

# Date of second blood sample of HbA1c >=48 mmol/mol:
do_pos_hba1c_2 <- hba1c_pos_censor_gdm[, .SD[2], by = PNR]

# And two 'unnecessary' variables used to inspect the population:

# Date of the most recent HbA1c sample >=48 mmol/mol:
do_pos_hba1c_N <- hba1c_pos_censor_gdm[, .SD[.N], by = PNR]

# Total number of HbA1c samples >= 48mmol/mol:
number_of_pos_hba1c <- hba1c_pos_censor_gdm[, .N, by = PNR]

# Combine to form the HbA1c inclusion object. Carry over the corresponding sample values for inspection:
hba1c_inclusion <- Reduce(function(x,y) merge(x,y, by = 'PNR', all = TRUE),
                    list(do_pos_hba1c_1[, .(PNR, do_pos_hba1c_1 = as.Date(REALSAMPLECOLLECTIONTIME), pos_hba1c_1 = INTERNAL_REPLY_NUM)],
                         do_pos_hba1c_2[, .(PNR, do_pos_hba1c_2 = as.Date(REALSAMPLECOLLECTIONTIME), pos_hba1c_2 = INTERNAL_REPLY_NUM)],
                         do_pos_hba1c_N[, .(PNR, do_pos_hba1c_N = as.Date(REALSAMPLECOLLECTIONTIME), pos_hba1c_N = INTERNAL_REPLY_NUM)],
                         number_of_pos_hba1c[, .(PNR, number_of_pos_hba1c = N)]))

# 2.2.0: Inclusion Events from Prescription Data ----------------------------


# 2.2.1: Load Reimbursed Prescriptions Data ----------------------------

# 2.2.2: Censor Prescriptions for PCOS ---------------------------

# All prescriptions of metformine reimbursed by women before their 40th birthday,
# or prescriptions of metformine among women with relevant prescription indication codes:

a10_censor_pcos <- merge(lmdb_a10, bef_alltime[,.(PNR, KOEN, FOED_DAG)],
                         by = 'PNR', all.x = TRUE)

# Create PCOS censoring variable:
a10_censor_pcos[, PCOS_PRESCRIPTION :=
                  (ATC == 'A10BA02') & (KOEN == '2') & (as.duration(interval(FOED_DAG, EKSD)) %/% as.duration(years(1)) < 40)
                | INDO %in% c('0000781','0000092','0000276')]

# Count how many individuals have a censored medication inclusion event due to possible PCOS:
n_censored_events_a10_pcos <- nrow(a10_censor_pcos[PCOS_PRESCRIPTION == T, .SD[1], by = PNR])

# 2.2.3: Censor Prescriptions for GDM -------------------------------------

# Censor prescriptions in the same intervals that were used to censor positive HbA1c results in 2.1.2:
# Within [-40; 12] weeks from a birth, abortion or other cause of termination of pregnancy.
# Within [-40; 40] weeks from the first maternity care visit in a pregnancy with no ending registered in relation to it.

# Add GDM-censoring variable to the diagnostic prescriptions dataset:

# Merge pregnancy dates to prescription dates (cartesian join, memory beware):
a10_pregnancies <- merge(a10_censor_pcos[ ,.(PNR, EKSD)], pregnancy_dates, by = 'PNR', all.x = TRUE, allow.cartesian = TRUE)

# Add GDM-censoring variable to the prescriptions:
a10_pregnancies[, GDM_PRESCRIPTION :=
                   (TYPE == 'END'
                    # Within [-40; 12] weeks of a pregnancy ending.
                    & EKSD < (D_VISIT + (12*7))
                    & EKSD > (D_VISIT - (40*7)))
                 |
                   (TYPE == 'VISIT'
                    # Maternity care contacts are presumed to primarily take place in the last 28 weeks of a pregnancy,
                    # with 12 weeks added to account for potential registration delays,
                    # thus censoring within [-40; 28 + 12 = 40] weeks of a maternity contact (in absence of a related ending):
                    & EKSD < (D_VISIT + (40*7))
                    & EKSD > (D_VISIT - (40*7)))
                 ]

# Reduce the dataset from the bloated cartesian join.
# Remove recycled prescriptions due to multiple pregnancy dates from the same person:
a10_pregnancies <- a10_pregnancies[GDM_PRESCRIPTION == TRUE,.SD[1], by = .(PNR, EKSD)]

# Add the GDM censoring variable to the prescriptions dataset:
a10_censor_pcos_gdm <- merge(a10_censor_pcos,
                             a10_pregnancies,
                             by = c('PNR','EKSD'),
                             all.x = TRUE)

# Set NA's (persons with a reimbursed prescription, but no pregnancy dates) to FALSE:
a10_censor_pcos_gdm[, GDM_PRESCRIPTION := ifelse(is.na(GDM_PRESCRIPTION), FALSE, TRUE)]

# Count how many individuals have a censored medication inclusion event due to possible GDM:
n_censored_events_a10_gdm <- nrow(a10_censor_pcos_gdm[PCOS_PRESCRIPTION == FALSE & GDM_PRESCRIPTION == TRUE,
                                                      .SD[1], by = PNR])



# Finally, exclude prescriptions potentially due to PCOS or GDM:
a10_censor_pcos_gdm <- a10_censor_pcos_gdm[PCOS_PRESCRIPTION == FALSE & GDM_PRESCRIPTION == FALSE]

setkey(a10_censor_pcos_gdm, PNR, EKSD)

# 2.2.4: Prescription Inclusion Variables ---------------------------------

# Create the final prescription inclusion events for each individual:

# Date of first reimbursed prescription of antidiabetic drugs:
do_a10_1 <- a10_censor_pcos_gdm[, .SD[1], by = PNR]

# Date of second reimbursed prescription of antidiabetic drugs:
do_a10_2 <- a10_censor_pcos_gdm[, .SD[2], by = PNR]

# Date of the most recent reimbursed prescription of antidiabetic drugs:
do_a10_N <- a10_censor_pcos_gdm[, .SD[.N], by = PNR]

# Total number of reimbursed prescriptions of antidiabetic drugs:
number_of_a10 <- a10_censor_pcos_gdm[, .N, by = PNR]

# Combine to form the prescription inclusion object. Carry over the corresponding drug types for inspection:
a10_inclusion <- Reduce(function(x,y) merge(x,y, by = 'PNR', all = TRUE),
                  list(do_a10_1[, .(PNR, do_a10_1 = EKSD, a10_1_atc = ATC)],
                       do_a10_2[, .(PNR, do_a10_2 = EKSD, a10_2_atc = ATC)],
                       do_a10_N[, .(PNR, do_a10_N = EKSD)],
                       number_of_a10[, .(PNR, number_of_a10 = N)]))

# TODO: Creating variables for determining remission states go here in the future. Copy/paste from legacy scripts.



# 2.3.0: Inclusion Events from Patient Register Data ------------------------

# 2.3.1: Load Patient Register Data ----------------------------

lpr_dm <- lpr_dm[, .(PNR, C_DIAG, D_INDDTO, C_DIAGTYPE)]
setkey(lpr_dm, PNR, D_INDDTO)


# 2.3.2: Patient Register Inclusion Variables -----------------------------

# Create the LPR inclusion events for each individual:

# Date of first diagnosis of diabetes:
do_lpr_1 <- lpr_dm[, .SD[1], by = PNR]

# Date of second diagnosis of diabetes:
do_lpr_2 <- lpr_dm[, .SD[2], by = PNR]

# Date of most recent diagnosis of diabetes:
do_lpr_N <- lpr_dm[, .SD[.N], by = PNR]

# Total number of diagnoses of diabetes:
number_of_lpr <- lpr_dm[, .N, by = PNR]


# Combine to form the LPR inclusion object. Carry over the corresponding ICD-10 code and diagnosis type for inspection:
lpr_inclusion <- Reduce(function(x,y) merge(x,y, by = 'PNR', all = TRUE),
                        list(do_lpr_1[, .(PNR, do_lpr_1 = D_INDDTO, lpr_1_icd10 = C_DIAG, lpr_1_type = C_DIAGTYPE)],
                             do_lpr_2[, .(PNR, do_lpr_2 = D_INDDTO, lpr_2_icd10 = C_DIAG, lpr_2_type = C_DIAGTYPE)],
                             do_lpr_N[, .(PNR, do_lpr_N = D_INDDTO)],
                             number_of_lpr[, .(PNR, number_of_lpr = N)]))

# 2.4.0: Inclusion from Health Service Register Data ----------------------

# Inclusion based on registration of a diabetes-specific podiatrist service in the period from year 1990 onwards:

# 2.4.1: Load Health Service Register Data ---------------------------------

setkey(ssr_foot, PNR, REGDATE)


# 2.4.2: Health Service Register Inclusion Variables ----------------------

# Create the SSR inclusion events for each individual:

# Due to the way the registration (= accounting and payment) of health services is set up,
# a single visit will often have many services registered by the health care provider.
# To account for this, subsequent visits have to be limited to unique dates of services for each person:

# Date of first diabetes-specific podiatrist service:
do_foot_1 <- ssr_foot[, .SD[1], by = PNR]

# Date of second diabetes-specific podiatrist service:
do_foot_2 <- ssr_foot[, unique(REGDATE), PNR][, V1[2], by = PNR]

# Date of most recent diabetes-specific podiatrist service:
do_foot_N <- ssr_foot[, .SD[.N], by = PNR]

# Total number of diabetes-specific podiatrist services:
number_of_foot <- ssr_foot[, .N, by = .(PNR, REGDATE)][, length(REGDATE), by = PNR]

# Combine to form the SSR inclusion object:
foot_inclusion <- Reduce(function(x,y) merge(x,y, by = 'PNR', all = TRUE),
                   list(do_foot_1[, .(PNR, do_foot_1 = REGDATE)],
                        do_foot_2[, .(PNR, do_foot_2 = V1)],
                        do_foot_N[, .(PNR, do_foot_N = REGDATE)],
                        number_of_foot[, .(PNR, number_of_foot = V1)]))

# 3.0.0: Generate the Inclusion Table ------------------------------------

# Merge the 4 inclusion objects and sort inclusion events chronologically to
# identify the date of onset of diabetes as the second overall inclusion event for each person.


# 3.1.0: Load the Inclusion Data and Merge to Inclusion Table ------------------------------------------

dm_inclusion <- Reduce(function(x,y) merge(x,y, by = 'PNR', all = TRUE),
  list(
    hba1c_inclusion,
    a10_inclusion,
    lpr_inclusion,
    foot_inclusion
    )
  )

# 3.2.0: Sort Inclusion Events Chronologically ----------------------------

# First, a few 'unnecessary' variables for inspection:

# A variable for date of first inclusion event overall:
dm_inclusion[, do_event_1 := as.Date(apply(dm_inclusion[, c('do_pos_hba1c_1',
                                                            'do_pos_hba1c_2',
                                                            'do_a10_1',
                                                            'do_a10_2',
                                                            'do_lpr_1',
                                                            'do_lpr_2',
                                                            'do_foot_1',
                                                            'do_foot_2')],
                                           1, min, na.rm=TRUE))]

# With the type of the corresponding inclusion event:
dm_inclusion[, type_event_1 := apply(dm_inclusion[, c('do_pos_hba1c_1',
                                                      'do_pos_hba1c_2',
                                                      'do_a10_1',
                                                      'do_a10_2',
                                                      'do_lpr_1',
                                                      'do_lpr_2',
                                                      'do_foot_1',
                                                      'do_foot_2')],
                                     1, function(x) (names(sort(x)[1])))]


# Date of first repetition of an inclusion criterium:
dm_inclusion[, do_repetition := suppressWarnings(as.Date(apply(dm_inclusion[, c('do_pos_hba1c_2',
                                                               'do_a10_2',
                                                               'do_lpr_2',
                                                               'do_foot_2')],
                                              1, min, na.rm=TRUE)))]

dm_inclusion[, type_repetition := suppressWarnings(apply(dm_inclusion[, c('do_pos_hba1c_2',
                                                         'do_a10_2',
                                                         'do_lpr_2',
                                                         'do_foot_2')],
                                        1, function(x) (names(sort(x)[1]))))]


# Number of inclusion events overall:
dm_inclusion[, number_of_events := sum(number_of_pos_hba1c, number_of_a10, number_of_lpr, number_of_foot, na.rm=T), by = PNR]


# Date of the most recent inclusion event overall:

dm_inclusion[, do_most_recent := as.Date(apply(dm_inclusion[, c('do_pos_hba1c_N',
                                                                'do_a10_N',
                                                                'do_lpr_N',
                                                                'do_foot_N')],
                                               1, function(x) (sort(x, decreasing = T))[1]))]
dm_inclusion[, type_most_recent := factor(apply(dm_inclusion[, c('do_pos_hba1c_N',
                                                                 'do_a10_N',
                                                                 'do_lpr_N',
                                                                 'do_foot_N')],
                                                1, function(x) (names(sort(x, decreasing = T))[1])))]



# 3.3.0: Define the Onset of Diabetes -------------------------------------

# Add variable for date of second inclusion event overall:
# THIS DEFINES THE DATE OF DIABETES ONSET IN THE POPULATION:
dm_inclusion[, do_dm := as.Date(apply(dm_inclusion[, c('do_pos_hba1c_1',
                                                       'do_pos_hba1c_2',
                                                       'do_a10_1',
                                                       'do_a10_2',
                                                       'do_lpr_1',
                                                       'do_lpr_2',
                                                       'do_foot_1',
                                                       'do_foot_2')],
                                      1, function(x) (sort(x))[2]))]

# Corresponding type of the second event, for inspection purposes:
dm_inclusion[, type_event_2 := apply(dm_inclusion[, c('do_pos_hba1c_1',
                                                       'do_pos_hba1c_2',
                                                       'do_a10_1',
                                                       'do_a10_2',
                                                       'do_lpr_1',
                                                       'do_lpr_2',
                                                       'do_foot_1',
                                                       'do_foot_2')],
                                     1, function(x) (names(sort(x)[2])))]



# 3.3.1: Add Time-independent Variables to the Diabetes Population -------------

dm_inclusion <- merge(dm_inclusion, bef_alltime, by = 'PNR', all = TRUE)

# Sex:
dm_inclusion[, sex := as.factor(ifelse(KOEN=='1', 'M', 'F'))]

# Age at onset:
dm_inclusion[, age_at_onset :=
         round(as.duration(interval(FOED_DAG, do_dm)) %/% as.duration(years(1)), digits = 0)]

# 4.0.0: Define Type of Diabetes ------------------------------------------

# Diabetes type is defined by a combination of patterns in records of:
# - Reimbursed prescriptions for antidiabetic drugs (insulins vs. non-insulins) in the The Danish National Prescription Registry
# - Primary diagnoses of type-specific diabetes recorded in The National Danish Patient Register

## T1D is defined as either:
#  - Reimbursed prescriptions for insulins and never any prescriptions for non-insulins &
#   being coded with a T1D-specific diagnosis at least once among the hospital contacts recording a type-specific diagnosis of diabetes as the primary diagnosis.
# or
# - Having reimbursed a prescription for insulins as the first antidiabetic drug &
#   having reimbursed more than twice as much insulin compared to non-insulin in terms of defined daily doses (DDD) &
#   having a majority of primary diagnoses specifying T1D as opposed to T2D

# In addition: when extracting a live diabetes population on a given date,
# having reimbursed a prescription for insulins in the year prior is required a person to be defined as type 1 diabetes.
# With this definition, diabetes type is stable over time, but does change from year to year in a few individuals.

# To-do: Add diagrammeR digraph flow-chart to illustrate algorithm for defining diabetes type.



# 4.1.0 Variables for Diabetes Type based on Prescription Data --------------------------------------

# Diabetes type is based on reimbursed prescriptions outside of censoring intervals:
a10_censor_pcos_gdm <- readRDS(here('data/source/a10_censor_pcos_gdm.rds'))
setkey(a10_censor_pcos_gdm, PNR, EKSD)


# 4.1.1: Variable For Amounts Filled of Insulin vs. Non-insulins ----------

# Variable for total amount of antidiabetic drugs reimbursed per person, measured in DDD.
a10_censor_pcos_gdm[, DDD := APK * VOLUME]

a10_type <- merge(a10_censor_pcos_gdm[grep('^A10B|^A10AE5', ATC, invert = TRUE),.(a10a_DDD = sum(DDD) ), by = PNR],
                  a10_censor_pcos_gdm[grep('^A10B|^A10AE5', ATC), .(a10b_DDD = sum(DDD) ), by = PNR],  # Inkl. Xultophy
                  by = 'PNR', all= TRUE)

a10_type[, a10a_DDD := ifelse(is.na(a10a_DDD), 0, a10a_DDD)]
a10_type[, a10b_DDD := ifelse(is.na(a10b_DDD), 0, a10b_DDD)]


# Add binary variable for having used more than twice as much insulin compared to non-insulins:
a10_type[, a10a_2x_a10b := a10a_DDD/a10b_DDD > 2]
# This variable also makes it a requirement to have filled at least one prescription for insulin in order to be classified as T1D,
# Since, in R, divide-by-zero returns Inf.


# 4.1.2: Variable for First Antidiabetic Medication Used ------------------

# Variable for first type of antidiabetic drug reimbursed:

# dm_inclusion <- readRDS(here('data/source/dm_inclusion.rds'))

a10_type <- merge(a10_type, dm_inclusion[, .(PNR, do_dm, a10_1_atc)], by = 'PNR', all.x = TRUE)
# Recode as binary variable for insulin as first prescription or not:
a10_type[, insulin_first := ifelse(grepl('^A10B|^A10AE5', a10_1_atc), FALSE, TRUE)]

# Variable for insulin use within 180 days after onset of diabetes:
a10_type_insulin <- merge(a10_type,
                       a10_censor_pcos_gdm[grep('^A10B|^A10AE5', ATC, invert = TRUE), .(PNR, do_insulin = EKSD)],
                       by = "PNR",
                       all.x = T)

a10_type_insulin[, insulin_180 := ifelse(is.na(do_insulin) | do_insulin < do_dm | do_insulin > do_dm + 180, FALSE, TRUE)]

a10_type <- merge(a10_type,
                  a10_type_insulin[insulin_180 == T, .SD[1], .SDcols = c("insulin_180"), by = PNR],
                  by = "PNR",
                  all.x = T)
a10_type[, insulin_180 := ifelse(is.na(insulin_180), FALSE, insulin_180)]

# 4.1.3: Combined Medication Variable for Type Classification -------------

# To make type-algorithm more readable, combine the two above variables into one:

a10_type[, insulin_2x_and_180d := a10a_2x_a10b == TRUE & insulin_180 == TRUE]


# 4.1.4: Variable for Only Insulin Monotherapy ----------------------------

a10_type[, only_insulin := a10a_DDD > 0 & a10b_DDD == 0 ]



# 4.2.0: Variables for Diabetes Type based on Patient Register Data -------------------------------------------------------------------

# Count primary diagnoses specific for T1D (E10) and T2D (E11), respectively, in different hospital settings.
# Data from different hospital settings take precedence over one another in the following hierarchy:
# 1: Diagnoses from admission to an endocrinological specialty ward.
# 2: Diagnoses from outpatient contacts to an endocrinological specialty department.
# 3: Diagnoses from contacts to other medical specialty departments.

# Limit to diabetes type-specific primary diagnoses from endocrinological departments or other medical specialties:
lpr_dm <- lpr_dm[grepl('^DE1[01]', C_ADIAG) &
                   C_PATTYPE %in% c('0', '1', '2') &
                   (
      C_SPEC %in% c('008', '08', '8', '000', '00', '0', '001', '01', '1') |
        C_BLOK %in% c('001', '01', '1')
      ),
  .(PNR, C_ADIAG, D_INDDTO, C_BLOK, C_SPEC, C_PATTYPE)]
setkey(lpr_dm, PNR, D_INDDTO)


# Add variables for majority of type 1 diagnoses from endocrinological vs medical specialties:

# Variable for majority of diagnoses among inpatient contacts to endocrinological specialty departments:
adiags_endo <- lpr_dm[C_SPEC %in% c('008', '08', '8')]

count_adiags_endo <- merge(adiags_endo[grep('^DE10', C_ADIAG), .(t1d_adiags_endo = .N), by = PNR],
                           adiags_endo[grep('^DE11', C_ADIAG), .(t2d_adiags_endo = .N), by = PNR],
                                 by = 'PNR', all= TRUE)

# Set NA's (no primary diagnoses of the specific type of diabetes) to zero:
count_adiags_endo[, t1d_adiags_endo := ifelse(is.na(t1d_adiags_endo), 0, t1d_adiags_endo)]
count_adiags_endo[, t2d_adiags_endo := ifelse(is.na(t2d_adiags_endo), 0, t2d_adiags_endo)]

count_adiags_endo[, type_1_endo := t1d_adiags_endo > t2d_adiags_endo]

# Variable for any contact to other medical specialty departments incl. mixed-specialty departments:
adiags_medical <- lpr_dm[(C_SPEC %in% c('000', '00', '0', '001', '01', '1') | C_BLOK %in% c('001', '01', '1')) & C_PATTYPE %in% c('0', '1', '2')]

count_adiags_medical <- merge(adiags_medical[grep('^DE10', C_ADIAG), .(t1d_adiags_medical = .N), by = PNR],
                              adiags_medical[grep('^DE11', C_ADIAG), .(t2d_adiags_medical = .N), by = PNR],
                              by = 'PNR', all= TRUE)

count_adiags_medical[, t1d_adiags_medical := ifelse(is.na(t1d_adiags_medical), 0, t1d_adiags_medical)]
count_adiags_medical[, t2d_adiags_medical := ifelse(is.na(t2d_adiags_medical), 0, t2d_adiags_medical)]

count_adiags_medical[, type_1_medical := t1d_adiags_medical > t2d_adiags_medical]


# Variable for having exclusively type 2-specific primary diagnoses (at least three T2D and no T1D).
# Used to enable type 2 patients treated with insulin monotherapy (rare since the 2010's) to escape classification as type 1 diabetes:
count_adiags_anywhere <- merge(lpr_dm[grep('^DE10', C_ADIAG), .(t1d_adiags_anywhere = .N), by = PNR],
                               lpr_dm[grep('^DE11', C_ADIAG), .(t2d_adiags_anywhere = .N), by = PNR],
                               by = 'PNR', all= TRUE)

# Less than 3 type 2 diagnoses or at least one type 1 diagnosis (not used anymore, replaced by just t1d diagnoses):
count_adiags_anywhere[, less_3_t2d_or_1_t1d := t2d_adiags_anywhere < 3 | !is.na(t1d_adiags_anywhere)]


# 4.3.0: Define Diabetes Type Classification ---------------------------------------------

# Merge the above parameters into one table containing all individuals with diabetes:
dm_type <- Reduce(function(x,y) merge(x,y, by = 'PNR', all.x = TRUE),
                  list(dm_inclusion[!is.na(do_dm)],
                    a10_type[, .(PNR, insulin_2x_and_180d, only_insulin)],
                    count_adiags_endo[, .(PNR, type_1_endo)],
                    count_adiags_medical[, .(PNR, type_1_medical)],
                    count_adiags_anywhere[, .(PNR, less_3_t2d_or_1_t1d, any_t1d_diags = !is.na(t1d_adiags_anywhere))]
                    )
                  )

# NA's in the type_1-variables in the dm_type table correspond to individuals,
# who have never had a diabetes type-specific primary diagnosis of any kind from that hospital setting.
# The information from those NA's is needed to determine which setting to evaluate for
# classification of diabetes type, and are therefore kept.

# NA's in the only_insulin and insulin_2x_and_180d-variables correspond to individuals
# who have never reimbursed prescriptions of antidiabetic drugs, but have had at least
# one primary diagnosis of type-specific diabetes from any of the hospital settings.
# Similarly, NA's in the any_t1d_diags and less_3_t2d_or_1_t1d variables correspond to individuals who have reimbursed
# prescriptions of antidiabetic drugs, but have no type-specific diagnoses.
# For type-classification purposes, these variables should be considered FALSE (with the exception of less_3_t2d_or_1_t1d)and set accordingly:

dm_type[, only_insulin := ifelse(is.na(only_insulin), FALSE, only_insulin)]
dm_type[, insulin_2x_and_180d := ifelse(is.na(insulin_2x_and_180d), FALSE, insulin_2x_and_180d)]
dm_type[, any_t1d_diags := ifelse(is.na(any_t1d_diags), FALSE, any_t1d_diags)]
dm_type[, less_3_t2d_or_1_t1d := ifelse(is.na(less_3_t2d_or_1_t1d), TRUE, less_3_t2d_or_1_t1d)]
# Add variable for diabetes type:

# Logic paths to being classified as type 1 diabetes:

dm_type[,
        diabetes_type := factor(ifelse(
          only_insulin == TRUE,
          # Insulin monotherapy: Left branch of flow diagram:
          # Check of diagnoses:
          ifelse(any_t1d_diags == FALSE, 2, 1),
          # Not insulin monotherapy: Right branch of flow diagram:
          # Those with any T1D diagnoses:
          ifelse(any_t1d_diags == FALSE, 2,
                 # Diagnoses from endocrinological departments (if available):
                 ifelse(
                   !is.na(type_1_endo),
                   ifelse(
                     type_1_endo == FALSE,
                     2,
                     # And check medication pattern
                     # of those with a majority of primary diagnoses:
                     ifelse(insulin_2x_and_180d == FALSE, 2, 1)
                   ),
                   # Otherwise evaluate those from medical departments:
                   ifelse(
                     type_1_medical == FALSE,
                     2,
                     # And check medication pattern
                     # of those with a majority of primary diagnoses:
                     ifelse(insulin_2x_and_180d == FALSE, 2, 1)
                   )
                 ))
        ))]


# Crop to needed variables:
dm_population <- dm_type[, .(PNR, diabetes_type, do_dm, sex, date_of_birth = FOED_DAG, age_at_onset)]
