# Classify diabetes status using Danish registers.

This function requires that each source of register data is represented
as a single DuckDB object in R (e.g. a connection to Parquet files).
Each DuckDB object must contain a single table covering all years of
that data source, or at least the years you have and are interested in.

## Usage

``` r
classify_diabetes(
  kontakter,
  diagnoser,
  lpr_diag,
  lpr_adm,
  sysi,
  sssy,
  lab_forsker,
  bef,
  lmdb,
  stable_inclusion_start_date = "1998-01-01"
)
```

## Arguments

- kontakter:

  The contacts information table from the LPR3 patient register

- diagnoser:

  The diagnoses information table from the LPR3 patient register

- lpr_diag:

  The diagnoses information table from the LPR2 patient register

- lpr_adm:

  The administrative information table from the LPR2 patient register

- sysi:

  The SYSI table from the health service register

- sssy:

  The SSSY table from the health service register

- lab_forsker:

  The register for laboratory results for research

- bef:

  The BEF table from the civil register

- lmdb:

  The LMDB table from the prescription register

- stable_inclusion_start_date:

  Cutoff date after which inclusion events are considered true incident
  diabetes cases. Defaults to "1998-01-01", which is one year after the
  data on pregnancy events from the Patient Register are considered
  valid for dropping gestational diabetes-related purchases of
  glucose-lowering drugs. This default assumes that the user is using
  LPR and LMDB data from at least Jan 1 1997 onward. If the user only
  has access to LPR and LMDB data from a later date, this parameter
  should be set to one year after the beginning of the user's data
  coverage.

## Value

The same object type as the input data, which would be a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html)
type object.

## See also

See the
[osdc](https://steno-aarhus.github.io/osdc/reference/osdc-package.md)
vignette for a detailed description of the internal implementation of
this classification function.

## Examples

``` r
register_data <- simulate_registers(
  c(
    "kontakter",
    "diagnoser",
    "lpr_diag",
    "lpr_adm",
    "sysi",
    "sssy",
    "lab_forsker",
    "bef",
    "lmdb"
  ),
  n = 10000
)
classify_diabetes(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser,
  lpr_diag = register_data$lpr_diag,
  lpr_adm = register_data$lpr_adm,
  sysi = register_data$sysi,
  sssy = register_data$sssy,
  lab_forsker = register_data$lab_forsker,
  bef = register_data$bef,
  lmdb = register_data$lmdb
)
#> # A duckplyr data frame: 5 variables
#>    pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>    <chr>        <date>                <date>             <lgl>   <lgl>  
#>  1 489451932098 2019-10-29            2019-10-29         FALSE   TRUE   
#>  2 214175003479 2002-07-22            2002-07-22         FALSE   TRUE   
#>  3 519614472995 2017-10-02            2017-10-02         FALSE   TRUE   
#>  4 786291733149 2015-12-22            2015-12-22         FALSE   TRUE   
#>  5 913887012520 2025-03-24            2025-03-24         FALSE   TRUE   
#>  6 486214469378 2024-09-29            2024-09-29         FALSE   TRUE   
#>  7 266202604180 2022-06-14            2022-06-14         FALSE   TRUE   
#>  8 324242194760 2021-08-22            2021-08-22         FALSE   TRUE   
#>  9 835830947366 2013-02-19            2013-02-19         FALSE   TRUE   
#> 10 576628620010 2023-01-25            2023-01-25         FALSE   TRUE   
#> # ℹ more rows
```
