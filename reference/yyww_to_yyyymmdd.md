# Convert date format YYWW to YYYY-MM-DD

Since the exact date isn't given in the input, this function will set
the date to Monday of the week. As a precaution, a leading zero is added
if it has been removed. This can e.g., happen if the input was "0107"
and has been converted to a numeric 107. We need to export this function
so that it can be found when using Arrow to process the data.

## Usage

``` r
yyww_to_yyyymmdd(yyww)
```

## Arguments

- yyww:

  Character(s) of the format YYWW.

## Value

Date(s) in the format YYYY-MM-DD.

## Examples

``` r
if (FALSE) { # \dontrun{
yyww_to_yyyymmdd("0101")
yyww_to_yyyymmdd(c("0102", "0304"))
yyww_to_yyyymmdd(953)
} # }
```
