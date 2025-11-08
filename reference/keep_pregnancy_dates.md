# Simple function to get only the pregnancy event dates.

Simple function to get only the pregnancy event dates.

## Usage

``` r
keep_pregnancy_dates(lpr2, lpr3)
```

## Arguments

- lpr2:

  Output from `join_lpr2()`.

- lpr3:

  Output from `join_lpr3()`.

## Value

The same type as the input data, default as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.

## Examples

``` r
if (FALSE) { # \dontrun{
register_data <- simulate_registers(
  c("lpr_adm", "lpr_diag", "kontakter", "diagnoser"),
  n = 1000
)
lpr2 <- prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag)
lpr3 <- prepare_lpr3(register_data$diagnoser, register_data$kontakter)
keep_pregnancy_dates(lpr2, lpr3)
} # }
```
