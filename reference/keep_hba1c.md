# Keep rows with HbA1c above the required threshold.

In the `lab_forsker` register, NPU27300 is HbA1c in the modern units
(IFCC) while NPU03835 is HbA1c in old units (DCCT). Multiple elevated
results on the same day within each individual are deduplicated, to
account for the same test result often being reported twice (one for
IFCC, one for DCCT units).

## Usage

``` r
keep_hba1c(lab_forsker)
```

## Arguments

- lab_forsker:

  The `lab_forsker` register.

## Value

An object of the same input type, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html),
with three columns:

- `pnr`: Personal identification variable.

- `dates`: The dates of all elevated HbA1c test results.

## Details

The output is passed to the
[`drop_pregnancies()`](https://steno-aarhus.github.io/osdc/reference/drop_pregnancies.md)
function for filtering of elevated results due to potential gestational
diabetes (see below).
