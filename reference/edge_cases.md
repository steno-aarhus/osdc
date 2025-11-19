# Create a synthetic dataset of edge case inputs

This function generates a list of DuckDB tibbles representing the Danish
health registers and the data necessary to run the algorithm. The
dataset contains 23 individual cases (`pnr`s), each designed to test a
specific logical branch of the diabetes classification algorithm,
including inclusion, exclusion, censoring, and type classification
rules.

## Usage

``` r
edge_cases()
```

## Value

A named list of 9
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html)
objects, each representing a different health register: `bef`, `lmdb`,
`lpr_adm`, `lpr_diag`, `kontakter`, `diagnoser`, `sysi`, `sssy`, and
`lab_forsker`.

## Details

The generated data is used in `testthat` tests to ensure the algorithm
behaves as expected under a wide range of conditions, but it is also
intended to be explored by users to better understand how the algorithm
logic works.

## Examples

``` r
if (FALSE) { # \dontrun{
edge_cases()
} # }
```
