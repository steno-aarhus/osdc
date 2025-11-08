# Internal function flow

This document describes the flow of functions and objects within the
package, specifically within the main exposed function
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md).
It shows the data sources and how they enter or are used in the function
as well as how the different internal functions and logic are connected
to each other. A high-level overview of the flow is shown in the diagram
below.

``` mermaid
flowchart TD
  subgraph data_sources["Data sources"]
    lpr_diag[("lpr_diag")]
    lpr_adm[("lpr_adm")]
    kontakter[("kontakter")]
    diagnoser[("diagnoser")]
    sysi[("sysi")]
    sssy[("sssy")]
    lmdb[("lmdb")]
    lab_forsker[("lab_forsker")]
    bef[("bef")]
  end

  subgraph classify_diabetes["classify_diabetes()"]

    lpr_diag --> prepare_lpr2["prepare_lpr2()"]
    lpr_adm --> prepare_lpr2

    kontakter --> prepare_lpr3["prepare_lpr3()"]
    diagnoser --> prepare_lpr3

    prepare_lpr2 --> keep_pregnancy_dates["keep_pregnancy_dates()"]
    prepare_lpr3 --> keep_pregnancy_dates

    %% Keep
    sysi --> keep_podiatrist_services["keep_podiatrist_services()"]:::keep
    sssy --> keep_podiatrist_services

    prepare_lpr2 --> keep_diabetes_diagnoses["keep_diabetes_diagnoses()"]:::keep
    prepare_lpr3 --> keep_diabetes_diagnoses
    keep_diabetes_diagnoses --> add_t1d_diagnoses_cols["add_t1d_diagnoses_cols()"]

    lmdb --> keep_gld_purchases["keep_gld_purchases()"]:::keep

    lab_forsker --> keep_hba1c["keep_hba1c()"]:::keep

    %% Drop
    keep_gld_purchases --> drop_pcos["drop_pcos()"]:::drop
    bef --> drop_pcos

    drop_pcos --> drop_pregnancies["drop_pregnancies()"]:::drop
    keep_pregnancy_dates --> drop_pregnancies
    keep_hba1c --> drop_pregnancies
    drop_pregnancies --> add_insulin_purchases_cols["add_insulin_purchases_cols()"]

    %% Join and classify
    add_t1d_diagnoses_cols --> keep_two_earliest_events["keep_two_earliest_events()"]
    keep_podiatrist_services --> keep_two_earliest_events
    add_insulin_purchases_cols --> keep_two_earliest_events

    keep_two_earliest_events --> join_inclusions["join_inclusions()"]
    join_inclusions --> create_inclusion_dates["create_inclusion_dates()"]
    create_inclusion_dates --> classify_t1d["classify_t1d()"]

    keep_pregnancy_dates ~~~ drop_pcos

  end

  %% Styling
  classDef default fill:#EEEEEE, color:#000000, stroke:#000000
  classDef keep fill:lightblue
  classDef drop fill:orange
  style classify_diabetes fill:#FFFFFF, color:#000000
  style data_sources fill:#FFFFFF, color:#000000, stroke-width:0px
```

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
