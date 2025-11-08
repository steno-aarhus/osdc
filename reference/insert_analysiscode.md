# Insert additional analysis codes for HbA1c

Insert additional analysis codes for HbA1c

## Usage

``` r
insert_analysiscode(data, proportion = 0.3)
```

## Arguments

- data:

  A tibble.

- proportion:

  Proportion to re-sample. Defaults to 0.3.

## Value

A tibble. If a column is named `analysiscode`, a proportion of the
values are replaced by codes for HbA1c.
