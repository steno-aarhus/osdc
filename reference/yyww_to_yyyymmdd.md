# Convert date format YYWW to YYYY-MM-DD

Since the exact date isn't given in the input, this function will set
the date to Monday of the week. As a precaution, a leading zero is added
if it has been removed. This can e.g., happen if the input was "0107"
and has been converted to a numeric 107.

## Usage

``` r
yyww_to_yyyymmdd(yyww)
```

## Arguments

- yyww:

  Character(s) of the format YYWW.

## Value

Date(s) in the format YYYY-MM-DD.
