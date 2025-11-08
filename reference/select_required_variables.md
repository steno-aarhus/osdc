# Select the required variables from the register

This function selects only the required variables, convert to lower
case, and then check that the data types are as expected.

## Usage

``` r
select_required_variables(data, register, call = rlang::caller_env())
```

## Arguments

- data:

  The register to select columns from.

- register:

  The abbreviation of the register name. See list of abbreviations in
  [`get_register_abbrev()`](https://steno-aarhus.github.io/osdc/reference/get_register_abbrev.md).

- call:

  The environment where the function is called, so that the error
  traceback gives a more meaningful location.

## Value

Outputs the register with only the required variables, and with column
names in lower case.

## Examples

``` r
if (FALSE) { # \dontrun{
select_required_variables(simulate_registers("bef")[[1]], "bef")
select_required_variables(simulate_registers("lpr_adm")[[1]], "lpr_adm")
} # }
```
