# 1: Run Import Script to Convert Raw Files from SAS Format --------

# Set path to root of raw files folder, e.g.:
foreign_folder = 'E:/ProjektDB/ALMAU/Rawdata/707517/'

# Set names of files to be imported. Can be split across multiple virtual machines for saving time.
# Executing everything on one machine works fine too.

# To run in 3 simultaneous chuncks on 3 virtual machines, run each of the following sections of 3 lines on a different machine:
sas_files_1 <- "^bef|^lpr_diag|^uaf_diag|^lpr_adm|^uaf_adm|.*sksube201[4-8]"
sas_file_list <- list.files(path = foreign_folder, pattern = sas_files_1, recursive = T)
source(here("R/import.R"))

#
sas_files_2 <- "^sysi|^sssy200[6-9]|^sssy20[1-9]"
sas_file_list <- list.files(path = foreign_folder, pattern = sas_files_2, recursive = T)
source(here("R/import.R"))

#
sas_files_3 <- "^lab|^lmdb"

sas_files_3 <- "^udda|^akm|^faik"
sas_file_list <- list.files(path = foreign_folder, pattern = sas_files_3, recursive = T)
source(here("R/import.R"))

# Set path to root of secondary raw files folder, e.g.:
foreign_folder = 'E:/ProjektDB/ALMAU/Rawdata/707517/Eksterne data/2021-06-09 fra SDS/'
sas_files_3 <- "^lab_forsker"
sas_file_list <- list.files(path = foreign_folder, pattern = sas_files_3, recursive = T)
source(here("R/import.R"))


# Note exclusion of either of sssy and sysi in 2005, where they potentially overlap.
# Note also that we import medication prescriptions from all years, even though we only filter and use those from 1997 onwards.


# 2: Run Filter Script to Create Source Data ---------------------------------

source(here("R/filter.R"))



# 3: Run Population Script to Generate Diabetes Population -------------------
source(here("R/population.R"))


# 4: Draw a Live Sample of the Diabetes Population at a Point in Time--------------------
source(here("R/draw_dm_sample.R"))

# Import the entire diabetes population through time:
dm_population <- readRDS(here('data/output/dm_population.rds'))
# Select which year to draw the population:

dm_2019 <- draw_dm_sample(sample_year = 2019)
saveRDS(dm_2019, here("data/output/dm_population_2019.rds"))

rm(dm_population, dm_2018)

# And draw the corresponding diagrams:
source(here("R/flowcharts.R"))
load(here("data", "source", "flowchart_counts.Rdata"))
draw_inclusion()
draw_type(sample_year = 2019)


# 5: Compress Imported Raw Data to Save Space -----------------------------

compress = TRUE
# Can be set to FALSE if wanting to uncompress the raw data at a later point

source(here("R/compress.R"))
