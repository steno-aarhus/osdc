# Internal function flow

This document describes the flow of functions and objects within the
package, specifically within the main exposed function
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md).
It shows the data sources and how they enter or are used in the function
as well as how the different internal functions and logic are connected
to each other. A high-level overview of the flow is shown in the diagram
below.

![](images/function-flow.svg)

Flow of functions in, as well as their required input registers, in the
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
function used for classifying diabetes status using the osdc package.
Light blue and orange boxes represent filtering functions (`keep_*` and
`drop_*`, respectively).

The sections below are split into functions for keeping and dropping
events as well as functions for determining the final diagnosis date and
eventual classification of type 1 and type 2 diabetes.

For more details and descriptions about the individual steps within the
algorithm, see the documentation on the internal functions:

- [`prepare_lpr2()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr2.md)
- [`prepare_lpr3()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr3.md)
- [`keep_pregnancy_dates()`](https://steno-aarhus.github.io/osdc/reference/keep_pregnancy_dates.md)
- [`keep_diabetes_diagnoses()`](https://steno-aarhus.github.io/osdc/reference/keep_diabetes_diagnoses.md)
- [`add_t1d_diagnoses_cols()`](https://steno-aarhus.github.io/osdc/reference/add_t1d_diagnoses_cols.md)
- [`keep_podiatrist_services()`](https://steno-aarhus.github.io/osdc/reference/keep_podiatrist_services.md)
- [`keep_hba1c()`](https://steno-aarhus.github.io/osdc/reference/keep_hba1c.md)
- [`keep_gld_purchases()`](https://steno-aarhus.github.io/osdc/reference/keep_gld_purchases.md)
- [`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md)
- [`drop_pregnancies()`](https://steno-aarhus.github.io/osdc/reference/drop_pregnancies.md)
- [`add_insulin_purchases_cols()`](https://steno-aarhus.github.io/osdc/reference/add_insulin_purchases_cols.md)
- [`keep_two_earliest_events()`](https://steno-aarhus.github.io/osdc/reference/keep_two_earliest_events.md)
- [`join_inclusions()`](https://steno-aarhus.github.io/osdc/reference/join_inclusions.md)
- [`create_inclusion_dates()`](https://steno-aarhus.github.io/osdc/reference/create_inclusion_dates.md)
- [`classify_t1d()`](https://steno-aarhus.github.io/osdc/reference/classify_t1d.md)
