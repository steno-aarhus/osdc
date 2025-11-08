# Convert column names to lower case

Convert column names to lower case

## Usage

``` r
column_names_to_lower(data)
```

## Arguments

- data:

  An data frame type object.

## Value

The same object type given.

## Examples

``` r
if (FALSE) { # \dontrun{
tibble::tibble(A = 1:3, B = 4:6) |>
  osdc:::column_names_to_lower()
} # }
```
