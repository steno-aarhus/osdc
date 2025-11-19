# Prepare and join the two LPR3 registers to extract diabetes and pregnancy diagnoses.

The output is used as inputs to
[`keep_diabetes_diagnoses()`](https://steno-aarhus.github.io/osdc/reference/keep_diabetes_diagnoses.md)
and to
[`keep_pregnancy_dates()`](https://steno-aarhus.github.io/osdc/reference/keep_pregnancy_dates.md).

## Usage

``` r
prepare_lpr3(kontakter, diagnoser)
```

## Arguments

- kontakter:

  The LPR3 register containing hospital contacts/admissions.

- diagnoser:

  The LPR3 register containing diabetes diagnoses.

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

## Examples

``` r
if (FALSE) { # \dontrun{
register_data <- simulate_registers(c("diagnoser", "kontakter"), 100000)
prepare_lpr3(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser
)
} # }
```
