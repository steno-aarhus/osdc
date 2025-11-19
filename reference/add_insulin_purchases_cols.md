# Add columns for information about insulin drug purchases

Add columns for information about insulin drug purchases

## Usage

``` r
add_insulin_purchases_cols(gld_hba1c_after_drop_steps)
```

## Arguments

- gld_hba1c_after_drop_steps:

  The GLD and HbA1c data after drop steps

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html).
Three new columns are added:

- `has_two_thirds_insulin`: A logical variable used in classifying type
  1 diabetes. See
  [`algorithm()`](https://steno-aarhus.github.io/osdc/reference/algorithm.md)
  for more details.

- `has_only_insulin_purchases`: A logical variable used in classifying
  type 1 diabetes. See
  [`algorithm()`](https://steno-aarhus.github.io/osdc/reference/algorithm.md)
  for more details.

- `has_insulin_purchases_within_180_days`: A logical variable used in
  classifying type 1 diabetes. See
  [`algorithm()`](https://steno-aarhus.github.io/osdc/reference/algorithm.md)
  for more details.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.

## Examples

``` r
if (FALSE) { # \dontrun{
simulate_registers("lmdb", 10000)[[1]] |>
  keep_gld_purchases() |>
  add_insulin_purchases_cols()
} # }
```
