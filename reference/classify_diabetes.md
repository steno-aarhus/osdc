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
# Can't run this multiple times, will cause an error as the table
# has already been created in the DuckDB connection.
register_data <- registers() |>
  names() |>
  simulate_registers() |>
  purrr::map(duckplyr::as_duckdb_tibble) |>
  purrr::map(duckplyr::as_tbl)

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
#> # Source:   SQL [?? x 5]
#> # Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/Rtmp6XktRg/duckplyr/duckplyr19516bb48598.duckdb]
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 732715981647 2020-08-24            2020-08-24         FALSE   TRUE   
#> 2 387790081572 2017-12-28            2017-12-28         FALSE   TRUE   
#> 3 706974528463 2023-03-06            2023-03-06         FALSE   TRUE   
#> 4 891077641572 2019-12-05            2019-12-05         FALSE   TRUE   
#> 5 222716976101 2013-09-18            2013-09-18         FALSE   TRUE   
#> 6 298944792608 2008-11-10            2008-11-10         FALSE   TRUE   
#> 7 498989088479 2017-11-27            2017-11-27         FALSE   TRUE   
#> 8 409442575549 2014-06-02            2014-06-02         FALSE   TRUE   
#> 9 240771768588 2024-01-29            2024-01-29         FALSE   TRUE   
```
