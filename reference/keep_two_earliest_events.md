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

The same type as the input data.

## Details

This function is applied to each "stream", `diabetes_diagnoses`,
`podiatrist_services`, and `gld_hba1c_after_drop_steps`, in the
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
function after the keep and drop steps, right before they are joined.
