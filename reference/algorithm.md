# A list of the algorithmic logic underlying osdc.

This nested list contains the logic details of the algorithm.

## Usage

``` r
algorithm()
```

## Format

Is a list with nested lists that have these named elements:

- register:

  Optional. The register used for this logic

- title:

  The title to use when displaying the logic in tables.

- logic:

  The logic itself.

- comments:

  Some additional comments on the logic.

## Value

A nested list with the algorithmic logic. Contains fields `register`,
`title`, `logic`, and `comments`.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.

## Examples

``` r
algorithm()$is_hba1c_over_threshold
#> $register
#> [1] "lab_forsker"
#> 
#> $title
#> [1] "HbA1c values over threshold"
#> 
#> $logic
#> [1] "(analysiscode == 'NPU27300' AND value >= 48) OR (analysiscode == 'NPU03835' AND value >= 6.5)"
#> 
#> $comments
#> [1] "Is the IFCC units for NPU27300 and DCCT units for NPU03835."
#> 
algorithm()$is_gld_code$logic
#> [1] "atc =~ '^A10' AND NOT (atc =~ '^(A10BJ|A10BK01|A10BK03)')"
```
