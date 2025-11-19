# Keep rows with diabetes-specific podiatrist services.

This function uses the `sysi` or `sssy` registers as input to extract
the dates of all diabetes-specific podiatrist services. Removes
duplicate services on the same date.

## Usage

``` r
keep_podiatrist_services(sysi, sssy)
```

## Arguments

- sysi:

  The SYSI register.

- sssy:

  The SSSY register.

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html).

- `pnr`: Identifier variable

- `date`: The dates of the first and second diabetes-specific podiatrist
  record

## Details

The output is passed to the
[`join_inclusions()`](https://steno-aarhus.github.io/osdc/reference/join_inclusions.md)
function for the final step of the inclusion process.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.

## Examples

``` r
if (FALSE) { # \dontrun{
register_data <- simulate_registers(c("sysi", "sssy"), 100)
keep_(register_data$sysi, register_data$sssy)
} # }
```
