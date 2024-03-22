# osdc (development version)

## General

-   Started package setup and infrastructure.

## Documentation

-   Added drafts of vignettes on Getting Started in `vignette("osdc")`
    (#53)
-   Added multiple sections to the design of the package and algorithm
    in `vignette("design")` (#42, #43, #56, #57, #51)
-   Added draft of rationale for the package and algorithm in
    `vignette("rationale")` (#63).

## Data

-   Added a dataset that contains the list of variables and registers we
    need for the algorithm to work with `variable_description` (#37,
    #48).

## Internal

-   Added function to internally verify that the input register database
    contains the necessary variables for the algorithm to work, using
    `verify_required_variables()` (#45).
-   Added function to convert all columns to lower case in the register
    database, using `column_names_to_lower()` (#60).
