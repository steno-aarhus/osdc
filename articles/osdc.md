# Getting started

## What does this package do?

The osdc (Open Source Diabetes Classifier) package classifies
individuals as having type 1 diabetes (T1D) or type 2 diabetes (T2D)
based on Danish register data. You provide the register data, and the
package returns a data table of individuals identified as having
diabetes, along with their diabetes type (T1D or T2D) and the date of
the classification.

This package serves two overarching purposes:

1.  To provide an open-source, code-based algorithm to classify type 1
    and type 2 diabetes using Danish registers as data sources.
2.  To inspire discussions within the Danish register-based research
    space on the openness and ease of use on the existing tooling and
    registers, and on the need for an official process for updating or
    contributing to existing data sources.

For a detailed description of the algorithm, see
[`vignette("algorithm")`](https://steno-aarhus.github.io/osdc/articles/algorithm.md).
For the motivations and rationale behind this package, see
[`vignette("rationale")`](https://steno-aarhus.github.io/osdc/articles/rationale.md).
For a full list of required register variables, see
[`vignette("data-sources")`](https://steno-aarhus.github.io/osdc/articles/data-sources.md).

## Step-by-step usage

This section walks through the full workflow: loading the package,
preparing data, running the classification, as well as understanding and
saving the output. We use simulated data here, but the same or similar
steps apply to real register data. For more information on using osdc on
real register data, see
[Section 3](#sec-working-with-real-register-data).

### Step 1: Install and load the package

First, you need to install and load the package:

``` r
# install.packages("osdc")
library(osdc)
```

### Step 2: Check which registers are needed

The algorithm requires data from multiple Danish registers. The names of
these registers can be seen below:

| Register abbreviation | Register name                                       |
|:----------------------|:----------------------------------------------------|
| bef                   | CPR-registerets befolkningstabel                    |
| lmdb                  | Laegemiddelstatistikregisteret                      |
| lpr_adm               | Landspatientregisterets administrationstabel (LPR2) |
| lpr_diag              | Landspatientregisterets diagnosetabel (LPR2)        |
| kontakter             | Landspatientregisterets kontakttabel (LPR3)         |
| diagnoser             | Landspatientregisterets diagnosetabel (LPR3)        |
| sysi                  | Sygesikringsregisteret                              |
| sssy                  | Sygesikringsregisteret                              |
| lab_forsker           | Laboratoriedatabasens forskertabel                  |

For a table showing the specific variables needed from each register,
see
[`vignette("data-sources")`](https://steno-aarhus.github.io/osdc/articles/data-sources.md).

> **Important**
>
> To use the osdc algorithm, you need to have all the variables
> described in
> [`vignette("data-sources")`](https://steno-aarhus.github.io/osdc/articles/data-sources.md),
> so please ensure that you have the required variables before
> continuing.

### Step 3: Prepare the data

The package requires data to be in [DuckDB](https://duckdb.org/) format,
which is a high-performance database format that can handle the large
volumes of data without loading everything into memory at once. See
[`vignette("design")`](https://steno-aarhus.github.io/osdc/articles/design.md)
for more on why we use DuckDB.

For this example, we generate simulated register data using
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md)
and then convert it to DuckDB format:

``` r
register_data <- registers() |>
  names() |>
  simulate_registers() |>
  purrr::map(duckplyr::as_duckdb_tibble) |>
  # Convert to a DuckDB connection, as duckplyr is still
  # in early development, while the DBI-DuckDB connection
  # is more stable.
  purrr::map(duckplyr::as_tbl)
```

The result is a named list where each element is one register as a
DuckDB table. The
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
function takes each register as a separate argument, so we extract them
into individual variables to be explicit about this:

``` r
bef <- register_data$bef
diagnoser <- register_data$diagnoser
lmdb <- register_data$lmdb
lpr_adm <- register_data$lpr_adm
lpr_diag <- register_data$lpr_diag
kontakter <- register_data$kontakter
sysi <- register_data$sysi
sssy <- register_data$sssy
lab_forsker <- register_data$lab_forsker
```

### Step 4: Run the classification

Now, we’re ready to run the classification algorithm. Pass each register
to
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md):

``` r
classified_diabetes <- classify_diabetes(
  kontakter = kontakter,
  diagnoser = diagnoser,
  lpr_diag = lpr_diag,
  lpr_adm = lpr_adm,
  sysi = sysi,
  sssy = sssy,
  lab_forsker = lab_forsker,
  bef = bef,
  lmdb = lmdb
)

classified_diabetes
#> # Source:   SQL [?? x 5]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.14.0-1017-azure:R 4.5.2//tmp/Rtmpn11iC6/duckplyr/duckplyr1e426287279a.duckdb]
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 108839343181 2018-08-30            2018-08-30         FALSE   TRUE   
#> 2 146605139851 2020-11-07            2020-11-07         FALSE   TRUE   
#> 3 240771768588 2016-11-28            2016-11-28         FALSE   TRUE   
#> 4 706974528463 2016-08-01            2016-08-01         FALSE   TRUE   
#> 5 745611946809 2018-10-29            2018-10-29         FALSE   TRUE   
#> 6 298944792608 2007-11-26            2007-11-26         FALSE   TRUE   
#> 7 498989088479 2014-11-09            2014-11-09         FALSE   TRUE   
#> 8 732715981647 2020-08-24            2020-08-24         FALSE   TRUE   
#> 9 409442575549 2010-05-24            2010-05-24         FALSE   TRUE
```

As seen above, this returns a DuckDB table with the individuals
classified as having either T1D or T2D along with the date of the
classification. Each of the columns in the output is explained in
[Section 2.5.1](#sec-understanding-the-output) below.

### Step 5 (optional): Collect the results into R

Because the data is stored in DuckDB, the result above is a *lazy*
reference to a database query, i.e., the data has not been loaded into
R’s memory. To bring the results into R as a regular data frame, use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html):

``` r
classified_diabetes <- classified_diabetes |>
  dplyr::collect()

classified_diabetes
#> # A tibble: 9 × 5
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 706974528463 2016-08-01            2016-08-01         FALSE   TRUE   
#> 2 745611946809 2018-10-29            2018-10-29         FALSE   TRUE   
#> 3 108839343181 2018-08-30            2018-08-30         FALSE   TRUE   
#> 4 409442575549 2010-05-24            2010-05-24         FALSE   TRUE   
#> 5 146605139851 2020-11-07            2020-11-07         FALSE   TRUE   
#> 6 298944792608 2007-11-26            2007-11-26         FALSE   TRUE   
#> 7 498989088479 2014-11-09            2014-11-09         FALSE   TRUE   
#> 8 732715981647 2020-08-24            2020-08-24         FALSE   TRUE   
#> 9 240771768588 2016-11-28            2016-11-28         FALSE   TRUE
```

Now, we can see that with the simulated data, 9 individuals are
classified as having diabetes.

#### Understanding the output

The output is a table with one row per classified individual and five
columns:

| Column                  | Description                                                                                                                                                                                                                                   |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `pnr`                   | The pseudonymised personal identification number.                                                                                                                                                                                             |
| `stable_inclusion_date` | The inclusion date, which is the date of the second inclusion event, but only if it falls within a period of reliable data coverage set by the `stable_inclusion_start_date` parameter (from 1998 onward by default). `NA` for earlier dates. |
| `raw_inclusion_date`    | The date of the second inclusion event without setting `NA` for date earlier than the `stable_inclusion_start_date`.                                                                                                                          |
| `has_t1d`               | `TRUE` if classified as type 1 diabetes, `FALSE` otherwise.                                                                                                                                                                                   |
| `has_t2d`               | `TRUE` if classified as type 2 diabetes, `FALSE` otherwise.                                                                                                                                                                                   |

> **About `stable_inclusion_date` vs `raw_inclusion_date`**
>
> The `raw_inclusion_date` is simply the date of the second qualifying
> event. However, for events before 1998, the register data may not have
> sufficient coverage to reliably distinguish new (incident) cases from
> existing (prevalent) ones. The `stable_inclusion_date` column is set
> to `NA` for these earlier dates to flag this uncertainty.
>
> The
> [`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
> function includes a `stable_inclusion_start_date` parameter that is
> `01-01-1988` by default. This means that you can change the date for
> when the classification is considered stable

For more information about the output, see the Interface section under
[`vignette("design")`](https://steno-aarhus.github.io/osdc/articles/design.md).

### Step 6: Saving the results

Once you have the classification results, you can save them as a Parquet
file for yourself or your collaborators on your DST project:

``` r
classified_diabetes |>
  duckplyr::as_duckdb_tibble() |>
  duckplyr::compute_parquet(
    "classified_diabetes.parquet"
  )
```

## Working with real register data

In a real scenario, the register data is too large to read into memory
all at once. We recommend converting your register files into
[Parquet](https://parquet.apache.org/) format on disk, with each
register in its own folder (e.g., all `kontakter` files in one folder,
all `diagnoser` files in another, etc.).

You can then load each register directly from its Parquet folder as a
DuckDB table, without reading everything into memory:

``` r
diagnoser <- "path/to/diagnoser_parquet_folder" |>
  arrow::open_dataset(unify_schemas = TRUE) |>
  arrow::to_duckdb()
```

> **Tip**
>
> If your register data is in SAS format (`.sas7bdat`), you can use the
> [fastreg](https://dp-next.github.io/fastreg/) package (once its been
> submitted to CRAN, expected March 2026) to convert them to Parquet
> format.

If your data is already in R (e.g., as a data frame) and fits in memory,
you can convert it to a DuckDB table with:

``` r
diagnoser <- diagnoser |>
  arrow::to_duckdb()
```

## Getting help

If you encounter a bug or have a question about how to use osdc, please
open an issue on the [GitHub
repository](https://github.com/steno-aarhus/osdc/issues). When reporting
a bug, include a minimal example that reproduces the problem along to
help us understand and investigate the problem.
