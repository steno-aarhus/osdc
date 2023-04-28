# Depends:
source(here::here("R/packages.R"))


draw_dm_sample <- function(population = dm_population,
                           population_counts = here("data", "source", "flowchart_counts.Rdata"),
                           sample_year) {

  # Individuals with onset of diabetes before sample date
  pop <- population[do_dm < as.Date(paste(sample_year, '-01-01', sep = ''))]

  # Individuals with diabetes living in the area on January 1st that year.
  bef  <- as.data.table(readRDS(paste(here('data/raw/bef'), sample_year, '.sas7bdat.rds', sep = '')))
  names(bef) <- toupper(names(bef))
  bef <- bef[, .(PNR, REG, age = ALDER, do_birth = FOED_DAG)]
  dm_sample <- merge(pop, bef, by = 'PNR', all = F)


  # Recode as T2D the T1D without reimbursed prescriptions of insulin in the prior year:
  a10a_prior <- as.data.table(readRDS(paste(here('data/raw/lmdb'), sample_year-1, '.sas7bdat.rds', sep = '')))
  names(a10a_prior) <- toupper(names(a10a_prior))
  a10a_prior <- a10a_prior[grepl('^A10A', ATC), .N, by = PNR]
  dm_sample <- merge(dm_sample, a10a_prior, by = 'PNR', all.x = TRUE)

  # For drawing inclusion diagram:
  load(population_counts)

  flowchart_sample <- merge(dm_sample, dm_type[, c(
    "PNR",
    "insulin_2x_and_180d",
    "only_insulin",
    "type_1_endo",
    "type_1_medical",
    "any_t1d_diags"
  )], by = "PNR", all.x = T)
  # Left branch:
  # T1D:
  n_insulin_prev_year_left_yes <- nrow(flowchart_sample[only_insulin == TRUE & any_t1d_diags == TRUE & !is.na(N)])
  n_insulin_prev_year_left_no <- nrow(flowchart_sample[only_insulin == TRUE & any_t1d_diags == TRUE & is.na(N)])

  # Right branch
  n_insulin_prev_year_right_yes <-
    nrow(flowchart_sample[only_insulin == FALSE & any_t1d_diags == TRUE &
                            !is.na(type_1_endo) & type_1_endo == TRUE &
                            insulin_2x_and_180d == TRUE & !is.na(N)]) +
    nrow(flowchart_sample[only_insulin == FALSE & any_t1d_diags == TRUE &
                            is.na(type_1_endo) & type_1_medical == TRUE &
                            insulin_2x_and_180d == TRUE & !is.na(N)])

  n_insulin_prev_year_right_no <-
    nrow(flowchart_sample[only_insulin == FALSE & any_t1d_diags == TRUE &
                            !is.na(type_1_endo) & type_1_endo == TRUE &
                            insulin_2x_and_180d == TRUE & is.na(N)]) +
    nrow(flowchart_sample[only_insulin == FALSE & any_t1d_diags == TRUE &
                            is.na(type_1_endo) & type_1_medical == TRUE &
                            insulin_2x_and_180d == TRUE & is.na(N)])


  # Actually recode T1D cases accordingly:

  dm_sample[, diabetes_type := factor(ifelse(diabetes_type == '1' & is.na(N), '2', diabetes_type))]
  dm_sample[, N := NULL]
  dm_sample[, diabetes_duration_years :=
              as.duration(
                interval(do_dm, as.Date(paste(sample_year, '-01-01', sep = '')))
              ) / as.duration(years(1))]
  dm_sample[, age :=
              as.duration(
                interval(do_birth, as.Date(paste(sample_year, '-01-01', sep = '')))
              ) / as.duration(years(1))]

  # Overall numbers before recoding:
  n_t1d_precrop <- nrow(flowchart_sample[diabetes_type == 1])
  n_t2d_precrop <- nrow(flowchart_sample[diabetes_type == 2])

  # And after:
  n_t1d_postcrop <- nrow(dm_sample[diabetes_type == 1])
  n_t2d_postcrop <- nrow(dm_sample[diabetes_type == 2])

  # Save counts
  dir_create(here("data", "source", "years", "flowchart", sample_year))


  save(list = c(ls()[grep("^n_", ls())]),
       file = here("data", "source", "years", "flowchart", sample_year,
                   paste0("flowchart_counts_", sample_year, ".Rdata")))



  return(dm_sample)
}
