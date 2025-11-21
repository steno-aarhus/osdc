# Drop pregnancy events that could be gestational diabetes.

This function takes the combined outputs from
[`keep_pregnancy_dates()`](https://steno-aarhus.github.io/osdc/reference/keep_pregnancy_dates.md),
[`keep_hba1c()`](https://steno-aarhus.github.io/osdc/reference/keep_hba1c.md),
and
[`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md)
and uses diagnoses from LPR2 or LPR3 to drop both elevated HbA1c tests
and GLD purchases during pregnancy, as these may be due to gestational
diabetes, rather than type 1 or type 2 diabetes. The aim is to identify
pregnancies based on diagnosis codes specific to pregnancy-ending events
(e.g. live births or miscarriages), and then use the dates of these
events to remove inclusion events in the preceding months that may be
related to gestational diabetes (e.g. elevated HbA1c tests or purchases
of glucose-lowering drugs during pregnancy).

## Usage

``` r
drop_pregnancies(dropped_pcos, pregnancy_dates, included_hba1c)
```

## Arguments

- dropped_pcos:

  Output from
  [`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md).

- pregnancy_dates:

  Output from
  [`keep_pregnancy_dates()`](https://steno-aarhus.github.io/osdc/reference/keep_pregnancy_dates.md).

- included_hba1c:

  Output from
  [`keep_hba1c()`](https://steno-aarhus.github.io/osdc/reference/keep_hba1c.md).

## Value

The same type as the input data, as a
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html).
Has the same output data as the input
[`drop_pcos()`](https://steno-aarhus.github.io/osdc/reference/drop_pcos.md),
except for a helper logical variable `no_pregnancy` that is used in
later functions.

## Details

After these drop functions have been applied, the output serves as
inputs to:

1.  The censored HbA1c and GLD data are passed to the
    [`join_inclusions()`](https://steno-aarhus.github.io/osdc/reference/join_inclusions.md)
    function for the final step of the inclusion process.

## See also

See the
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md)
for the logic used to filter these patients.
