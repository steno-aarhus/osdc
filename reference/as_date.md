# Simple `as.Date()` wrapper.

DuckDB doesn't support using
[`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html),
so this is a simple wrapper around
[`as.Date()`](https://rdrr.io/r/base/as.Date.html) with the correct
formats.

## Usage

``` r
as_date(x)
```

## Arguments

- x:

  A character (or date) column.

## Value

A Date column.
