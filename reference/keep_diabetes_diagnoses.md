# Keep rows with diabetes diagnoses.

This function uses the hospital contacts from LPR2 and LPR3 to include
all dates of diabetes diagnoses to use for inclusion, as well as
additional information needed to classify diabetes type. Diabetes
diagnoses from both ICD-8 and ICD-10 are included.

## Usage

``` r
keep_diabetes_diagnoses(lpr2, lpr3)
```

## Arguments

- lpr2:

  The output from
  [`prepare_lpr2()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr2.md).

- lpr3:

  The output from
  [`prepare_lpr3()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr3.md).

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html),
with less rows after filtering.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
