# Drop rows with metformin purchases that are potentially for the treatment of polycystic ovary syndrome

Takes the output from
[`keep_gld_purchases()`](https://steno-aarhus.github.io/osdc/reference/keep_gld_purchases.md)
and `bef` (information on sex and date of birth) to drop rows with
metformin purchases that are potentially for the treatment of polycystic
ovary syndrome. This function only performs a filtering operation so it
outputs the same structure and variables as the input from
[`keep_gld_purchases()`](https://steno-aarhus.github.io/osdc/reference/keep_gld_purchases.md),
except the addition of a logical helper variable `no_pcos` that is used
in later functions. After these rows have been dropped, the output is
used by
[`drop_pregnancies()`](https://steno-aarhus.github.io/osdc/reference/drop_pregnancies.md).

## Usage

``` r
drop_pcos(gld_purchases, bef)
```

## Arguments

- gld_purchases:

  The output from
  [`keep_gld_purchases()`](https://steno-aarhus.github.io/osdc/reference/keep_gld_purchases.md).

- bef:

  The `bef` register.

## Value

The same type as the input data, default as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).
It also has the same columns as
[`keep_gld_purchases()`](https://steno-aarhus.github.io/osdc/reference/keep_gld_purchases.md),
except for a logical helper variable `no_pcos` that is used in later
functions.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.

## Examples

``` r
if (FALSE) { # \dontrun{
register_data <- simulate_registers(c("lmdb", "bef"), 100)
drop_pcos(
  gld_purchases = keep_gld_purchases(register_data$lmdb),
  bef = register_data$bef
)
} # }
```
