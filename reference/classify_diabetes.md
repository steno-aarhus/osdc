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
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
type object.

## See also

See the
[osdc](https://steno-aarhus.github.io/osdc/reference/osdc-package.md)
vignette for a detailed description of the internal implementation of
this classification function.

## Examples

``` r
if (FALSE) { # \dontrun{
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
} # }
```
