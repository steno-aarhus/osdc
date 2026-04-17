# Classify diabetes status using Danish registers.

This function requires that each source of register data is represented
as a single DuckDB object in R (e.g. a connection to Parquet files).
Each DuckDB object must contain a single table covering all years of
that data source, or at least the years you have and are interested in.

## Usage

``` r
classify_diabetes(
  lpr,
  hsr,
  lab_forsker,
  bef,
  lmdb,
  stable_inclusion_start_date = "1998-01-01"
)
```

## Arguments

- lpr:

  The unified LPR register, see
  [`join_registers()`](https://steno-aarhus.github.io/osdc/reference/join_registers.md)

- hsr:

  The unified health services registers (SYSI and SSSY), see
  [`join_registers()`](https://steno-aarhus.github.io/osdc/reference/join_registers.md)

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
registers <- registers() |>
  names() |>
  simulate_registers() |>
  purrr::map(duckplyr::as_duckdb_tibble) |>
  purrr::map(duckplyr::as_tbl)

lpr <- list(
  prepare_lpr2(registers$lpr_adm, registers$lpr_diag),
  prepare_lpr3f(registers$lpr3f_kontakter, registers$lpr3f_diagnoser),
  prepare_lpr3a(registers$lpr3a_kontakt, registers$lpr3a_diagnose)
) |>
  join_registers()

hsr <- list(registers$sssy, registers$sysi) |> join_registers()

classify_diabetes(
  lpr = lpr,
  hsr = hsr,
  lab_forsker = registers$lab_forsker,
  bef = registers$bef,
  lmdb = registers$lmdb
)
#> # Source:   SQL [?? x 5]
#> # Database: DuckDB 1.5.2 [unknown@Linux 6.17.0-1010-azure:R 4.5.3//tmp/RtmpG7Uh0b/duckplyr/duckplyr19fd40d75a9c.duckdb]
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 732715981647 2016-12-19            2016-12-19         FALSE   TRUE   
#> 2 298944792608 2017-02-01            2017-02-01         FALSE   TRUE   
#> 3 498989088479 2014-11-09            2014-11-09         FALSE   TRUE   
#> 4 720437203185 2018-08-30            2018-08-30         FALSE   TRUE   
#> 5 409442575549 2020-05-04            2020-05-04         FALSE   TRUE   
#> 6 706974528463 2016-11-07            2016-11-07         FALSE   TRUE   
#> 7 240771768588 2016-04-04            2016-04-04         FALSE   TRUE   
```
