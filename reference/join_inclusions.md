# Join kept inclusion events.

This function joins the outputs from all the filtering functions, by
`pnr` and `dates`. Input datasets:

- `diabetes_diagnoses`: Dates are the first and second hospital diabetes
  diagnosis.

- `podiatrist_services`: Dates are the first and second
  diabetes-specific podiatrist record.

- `gld_hba1c_after_drop_steps`: Dates are the first and second elevated
  HbA1c test results (after excluding results potentially influenced by
  gestational diabetes), and the first and second purchase of a
  glucose-lowering drug (after excluding purchases potentially related
  to polycystic ovary syndrome or gestational diabetes).

## Usage

``` r
join_inclusions(
  diabetes_diagnoses,
  podiatrist_services,
  gld_hba1c_after_drop_steps
)
```

## Arguments

- diabetes_diagnoses:

  Output from
  [`keep_diabetes_diagnoses()`](https://steno-aarhus.github.io/osdc/reference/keep_diabetes_diagnoses.md).

- podiatrist_services:

  Output from
  [`keep_podiatrist_services()`](https://steno-aarhus.github.io/osdc/reference/keep_podiatrist_services.md).

- gld_hba1c_after_drop_steps:

  Output from
  [`drop_pregnancies()`](https://steno-aarhus.github.io/osdc/reference/drop_pregnancies.md)
  and
  [`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md).

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html),
with the joined columns from the output of
[`keep_diabetes_diagnoses()`](https://steno-aarhus.github.io/osdc/reference/keep_diabetes_diagnoses.md),
[`keep_podiatrist_services()`](https://steno-aarhus.github.io/osdc/reference/keep_podiatrist_services.md),
[`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md),
and
[`drop_pregnancies()`](https://steno-aarhus.github.io/osdc/reference/drop_pregnancies.md).
There will be 1-8 rows per `pnr`.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
