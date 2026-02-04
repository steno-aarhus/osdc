# Keep rows with diabetes-specific podiatrist services.

This function uses the `sysi` or `sssy` registers as input to extract
the dates of all diabetes-specific podiatrist services. Removes
duplicate services on the same date.

The output is passed to the
[`join_inclusions()`](https://steno-aarhus.github.io/osdc/reference/join_inclusions.md)
function for the final step of the inclusion process.

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
[`duckplyr::duckdb_tibble()`](https://rdrr.io/pkg/duckplyr/man/duckdb_tibble.html).

- `pnr`: Identifier variable

- `date`: The dates of the first and second diabetes-specific podiatrist
  record

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
