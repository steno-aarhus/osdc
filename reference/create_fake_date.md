# Create fake dates

Create fake dates

## Usage

``` r
create_fake_date(n, from = "1977-01-01", to = lubridate::today())
```

## Arguments

- n:

  The number of dates to generate.

- from:

  A date determining the first date in the interval to sample from.

- to:

  A date determining the last date in the interval to sample from.

## Value

A vector of dates.

## Examples

``` r
if (FALSE) { # \dontrun{
create_fake_date(20)
create_fake_date(20, "1995-04-19", "2024-04-19")
} # }
```
