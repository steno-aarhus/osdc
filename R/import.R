# User specifies the directory of the folder with the raw SAS-files and which file names to be imported. Script then imports all the necessary files:

# Depends:
source(here("R/packages.R"))

# Create folders used by import.R:
dir_create(here("data/raw"))


# Function for importing SAS to project:
import_sas <- function(filename, foreign_folder) {
  dt <- read_sas(paste(foreign_folder, '/', filename, sep='') )
  saveRDS(dt, paste(here('data/raw'), regmatches(filename, regexpr('/.*$',filename)),'.rds', sep=''), compress = TRUE)
  remove(dt)
}
# Compress can be set to TRUE to save space immediately (at the cost of speed in filter.R. Using compress.R after running filter.R is more optimal.)

# Set in master.R:
  # Regular expression to specify the files to import:
    # Separate strings for splitting up importing operations across multiple machines, if available
  # Set the root of the folders containing foreign file formats

# Execute the importation:

for (filename in sas_file_list) {
  import_sas(filename, foreign_folder)
}

rm(sas_files_1, sas_files_2, sas_files_3, sas_file_list)
