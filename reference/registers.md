# Register variables (with descriptions) required for the osdc algorithm.

Register variables (with descriptions) required for the osdc algorithm.

## Usage

``` r
registers()
```

## Source

Many of the details within the `registers()` metadata come from the full
official list of registers from Statistics Denmark (DST):
<https://www.dst.dk/extranet/forskningvariabellister/Oversigt%20over%20registre.html>

## Value

Outputs a list of registers and variables required by osdc. Each list
item contains the official Danish name of the register, the start year,
the end year, and the variables with their descriptions. The variables
item is a data frame with 4 columns:

- name:

  The official name of the variable found in the register.

- danish_description:

  The official Danish description of the variable.

- english_description:

  The translated English description of the variable.

- data_type:

  The data type, e.g. "character" of the variable. Could have multiple
  options (e.g. "Date" or "character").
