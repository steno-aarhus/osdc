# Add columns related to type 1 diabetes diagnoses

This function evaluates whether an individual has a majority of type 1
diabetes-specific hospital diagnoses (DE10) among all type-specific
diabetes primary diagnoses (DE10 & DE11) from endocrinology departments.
If an individual doesn't have any type-specific diabetes diagnoses from
endocrinology departments, the majority is determined by diagnoses from
medical departments.

It also adds a column indicating whether an individual has at least one
primary diagnosis related to type 1 diabetes.

This output is passed to the
[`join_inclusions()`](https://steno-aarhus.github.io/osdc/reference/join_inclusions.md)
function, where the `dates` variable is used for the final step of the
inclusion process. The variables for whether the majority of diagnoses
are for type 1 diabetes is used for later classification of type 1
diabetes.

## Usage

``` r
add_t1d_diagnoses_cols(data)
```

## Arguments

- data:

  Data from
  [`keep_diabetes_diagnoses()`](https://steno-aarhus.github.io/osdc/reference/keep_diabetes_diagnoses.md)
  function.

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html),
with the following added columns and up to two rows per individual:

- `has_majority_t1d_diagnoses`: A logical vector indicating whether the
  majority of primary diagnoses are related to type 1 diabetes.

- `has_any_t1d_primary_diagnosis`: A logical vector indicating whether
  there is at least one primary diagnosis related to type 1 diabetes.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
