# Prepare and join the two LPR3A registers to extract diabetes and pregnancy diagnoses.

Prepare and join the two LPR3A registers to extract diabetes and
pregnancy diagnoses.

## Usage

``` r
prepare_lpr3a(lpr3a_kontakt, lpr3a_diagnose)
```

## Arguments

- lpr3a_kontakt:

  The LPR3A register containing hospital contacts/admissions.

- lpr3a_diagnose:

  The LPR3A register containing diabetes diagnoses.

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html),
with the following columns:

- `pnr`: The personal identification variable.

- `date`: The date of all the recorded diagnosis (renamed from
  `d_inddto` or `dato_start`).

- `is_primary_diagnosis`: Whether the diagnosis was a primary diagnosis.

- `is_diabetes_code`: Whether the diagnosis was any type of diabetes.

- `is_t1d_code`: Whether the diagnosis was T1D-specific.

- `is_t2d_code`: Whether the diagnosis was T2D-specific.

- `is_pregnancy_code`: Whether the person has an event related to
  pregnancy like giving birth or having a miscarriage at the given date.

- `is_endocrinology_dept`: Whether the diagnosis was made by an
  endocrinology medical department.

- `is_medical_dept`: Whether the diagnosis was made by a
  non-endocrinology medical department.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
