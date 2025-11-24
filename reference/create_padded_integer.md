# Create a vector of reproducible, random zero-padded integers.

For a given number of generated integers that are the same length, they
will always be identical. This makes it easier to do joining by values
that represent people, e.g. in `pnr`, `cpr`, `recnum` and
`dw_ek_kontakt`.

## Usage

``` r
create_padded_integer(n, length)
```

## Arguments

- n:

  The number of integer strings to generate.

- length:

  The length of the padded integer strings.

## Value

A character vector of integers.
