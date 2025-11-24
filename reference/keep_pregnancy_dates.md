# Simple function to get only the pregnancy event dates.

Simple function to get only the pregnancy event dates.

## Usage

``` r
keep_pregnancy_dates(lpr2, lpr3)
```

## Arguments

- lpr2:

  Output from
  [`prepare_lpr2()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr2.md).

- lpr3:

  Output from
  [`prepare_lpr3()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr3.md).

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html).

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
