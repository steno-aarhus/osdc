# List of non-cases to test the diabetes classification algorithm

This function generates a list of DuckDB tibbles representing the Danish
health registers and the data necessary to run the algorithm. The
dataset contains individuals who should *not* be included in the final
classified cohort.

## Usage

``` r
non_cases()
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
logic works and to be shown in the documentation.

## Examples

``` r
non_cases()
#> Error in purrr::map(simulation_definitions_list, function(data) create_simulated_data(data,     n = n)): ℹ In index: 3.
#> Caused by error in `purrr::map()`:
#> ℹ In index: 4.
#> ℹ With name: hovedspeciale_ans.
#> Caused by error in `UseMethod()`:
#> ! no applicable method for 'html_table' applied to an object of class "xml_missing"
```
