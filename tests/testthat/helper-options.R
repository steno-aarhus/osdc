# There is a warning when using Arrow about using pull. It says to set
# this option.
options(
  arrow.pull_as_vector = TRUE,
  duckdb.materialize_message = FALSE
)
Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)
Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = FALSE)
