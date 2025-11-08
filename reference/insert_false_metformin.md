# Insert cases where metformin is used for other purposes than diabetes

This function uses the variable `indo` which is the code for the
underlying condition treated by the prescribed medication.

## Usage

``` r
insert_false_metformin(data, proportion = 0.05)
```

## Arguments

- data:

  A tibble.

- proportion:

  Proportion to re-sample. Defaults to 0.05.

## Value

A tibble. If all column names in the tibble is either `atc`, a
proportion of observations is re-sampled as metformin.
