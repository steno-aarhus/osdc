# Translate to SQL for datetime conversion to eventually date

DuckDB doesn't support using
[`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html),
so this uses
[`dbplyr::sql()`](https://dbplyr.tidyverse.org/reference/sql.html) to
directly use DuckDB's `strptime` to convert strings to datetimes.
Afterwards, it can be converted to dates.

## Usage

``` r
as_sql_datetime(x)
```

## Arguments

- x:

  A character (or date) column, in quotes.

## Value

A Datetime column.
