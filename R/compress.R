# Changes compression of imported raw files for saving space:

source(here("R/packages.R"))

compression_function <- function(filename, compress) {
  dt <- as.data.table(readRDS(paste(here("data/raw"), '/', filename, sep='') ) )
  saveRDS(dt, paste(here("data/raw"), '/', filename, sep='') )
  remove(dt)
}

for (filename in list.files(path = here("data/raw/"))) {
  compression_function(filename)
}
