# Create a vector with random ICD-8 or -10 diagnoses

Create a vector with random ICD-8 or -10 diagnoses

## Usage

``` r
create_fake_icd(n, date = NULL)
```

## Arguments

- n:

  The number of ICD-8 or -10 diagnoses to generate.

- date:

  A date determining whether the diagnoses should be ICD-8 or ICD-10. If
  null, a random date will be sampled to determine which ICD revision
  the diagnosis should be from. In the Danish registers, ICD-10 is used
  after 1994.

## Value

A character vector of ICD-10 diagnoses.

## Examples

``` r
if (FALSE) { # \dontrun{
create_fake_icd(10)
create_fake_icd(5, "1995-04-19")
} # }
```
