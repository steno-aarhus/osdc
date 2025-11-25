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
#>  1 734096773097 2021-06-03            2021-06-03         FALSE   TRUE   
#>  2 461545659514 2018-12-03            2018-12-03         FALSE   TRUE   
#>  3 213889562173 2016-05-23            2016-05-23         FALSE   TRUE   
#>  4 278805655411 2021-09-02            2021-09-02         FALSE   TRUE   
#>  5 980089718120 2023-05-29            2023-05-29         FALSE   TRUE   
#>  6 923730566500 2015-02-26            2015-02-26         FALSE   TRUE   
#>  7 786291733149 2015-12-22            2015-12-22         FALSE   TRUE   
#>  8 672323670158 2020-12-26            2020-12-26         FALSE   TRUE   
#>  9 300913020651 2022-03-29            2022-03-29         FALSE   TRUE   
#> 10 732779718856 2022-12-05            2022-12-05         FALSE   TRUE   
#> # ℹ more rows
```
