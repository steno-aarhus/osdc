# Create a vector of random ICD-10 diagnoses

ICD-10 is the 10th revision of the International Classification of
Diseases.

## Usage

``` r
create_fake_icd10(n)
```

## Source

The stored CSV is downloaded from the Danish Health Data Authority's
website at [medinfo.dk](https://medinfo.dk/sks/brows.php).

## Arguments

- n:

  An integer determining how many diagnoses to create.

## Value

A character vector of ICD-10 diagnoses.

## Examples

``` r
if (FALSE) { # \dontrun{
create_fake_icd10(3)
} # }
```
