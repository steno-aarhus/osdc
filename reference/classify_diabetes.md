# Classify diabetes status using Danish registers.

Classify diabetes status using Danish registers.

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

  The contacts register for lpr3

- diagnoser:

  The diagnoses register for lpr3

- lpr_diag:

  The diagnoses register for lpr2

- lpr_adm:

  The admissions register for lpr2

- sysi:

  The SYSI register

- sssy:

  The SSSY register

- lab_forsker:

  The lab forsker register

- bef:

  The BEF register

- lmdb:

  The LMDB register

- stable_inclusion_start_date:

  Cutoff date after which inclusion events are considered reliable
  (e.g., after changes in drug labeling or data entry practices).
  Defaults to "1998-01-01" which is one year after obstetric codes are
  reliable in the GLD data (since we use LPR data to drop rows related
  to gestational diabetes). This limits the included cohort to
  individuals with inclusion dates after this cutoff date.

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
#>  1 168521426137 2022-03-21            2022-03-21         FALSE   TRUE   
#>  2 489451932098 2019-10-29            2019-10-29         FALSE   TRUE   
#>  3 051920001271 2014-07-21            2014-07-21         FALSE   TRUE   
#>  4 684113124148 2017-05-23            2017-05-23         FALSE   TRUE   
#>  5 401134956023 2021-12-02            2021-12-02         FALSE   TRUE   
#>  6 085540938503 2025-06-17            2025-06-17         FALSE   TRUE   
#>  7 348704179509 2022-08-27            2022-08-27         FALSE   TRUE   
#>  8 134260948302 2021-12-22            2021-12-22         FALSE   TRUE   
#>  9 672323670158 2020-12-26            2020-12-26         FALSE   TRUE   
#> 10 936331023483 2014-07-18            2014-07-18         FALSE   TRUE   
#> # ℹ more rows
```
