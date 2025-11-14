# Keep two earliest events per PNR

Since the classification date is based on the second instance of an
inclusion criteria, we only need to keep the earliest two events per PNR
per inclusion "stream".

## Usage

``` r
keep_two_earliest_events(data)
```

## Arguments

- data:

  Data including at least a date and pnr column.

## Value

The same type as the input data, default as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Details

This function is applied to each "stream", `diabetes_diagnoses`,
`podiatrist_services`, and `gld_hba1c_after_drop_steps`, in the
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
function after the keep and drop steps, right before they are joined.

## Examples

``` r
if (FALSE) { # \dontrun{
data <- tibble::tribble(
  ~pnr, ~date,
  1, "20200101",
  1, "20200102",
  1, "20200103",
  2, "20200101"
)
keep_two_earliest_events(data)
} # }
```
