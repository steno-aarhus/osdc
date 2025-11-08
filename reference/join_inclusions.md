# Join kept events.

This function joins the outputs from all the filtering functions, by
`pnr` and `dates`. Input datasets:

- `diabetes_diagnoses`: Dates are the first and second hospital diabetes
  diagnosis.

- `podiatrist_services`: Dates are the first and second
  diabetes-specific podiatrist record.

- `gld_hba1c_after_drop_steps`: Dates are the first and second elevated
  HbA1c test results (after censoring potential gestational diabetes)
  and are the first and second purchase of a glucose-lowering drug
  (after censoring potential polycystic ovary syndrome and gestational
  diabetes).

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

The same type as the input data, default as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html),
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
