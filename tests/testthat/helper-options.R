options(
  # There is a warning when using Arrow about using pull. It says to set
  # this option.
  arrow.pull_as_vector = TRUE,
  # DuckDB outputs a lot of messages, this stops that.
  duckdb.materialize_message = FALSE
)
# By default, duckplyr logs messages and outputs them when it runs.
# Adding these options so the test output looks cleaner.
Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 0)
Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = FALSE)
