# Keep rows with purchases of glucose lowering drugs (GLD)

This function doesn't keep glucose-lowering drugs that may be used for
other conditions than diabetes like GLP-RAs or
dapagliflozin/empagliflozin drugs. Since the diagnosis code data on
pregnancies (see below) is insufficient to perform censoring prior to
1997, `keep_gld_purchases()` only extracts dates from 1997 onward by
default (if Medical Birth Register data is available to use for
censoring, the extraction window can be extended).

## Usage

``` r
keep_gld_purchases(lmdb)
```

## Arguments

- lmdb:

  The `lmdb` register.

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html).
Only rows with glucose lowering drug purchases are kept, plus some
columns are renamed.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
