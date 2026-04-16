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
| lpr3a_kontakt         | Landspatientregisterets kontakttabel (LPR3A)        |
| lpr3a_diagnose        | Landspatientregisterets diagnosetabel (LPR3A)       |
| lpr3f_kontakter       | Landspatientregisterets kontakttabel (LPR3F)        |
| lpr3f_diagnoser       | Landspatientregisterets diagnosetabel (LPR3F)       |
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
DuckDB table. The LPR data spans multiple versions (LPR2 and LPR3) that
need to be prepared and joined into a single table before being used as
input for
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md).
osdc provides helper functions for this:

``` r
lpr <- list(
  prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
  prepare_lpr3f(
    register_data$lpr3f_kontakter,
    register_data$lpr3f_diagnoser
  )
) |>
  join_lpr()
```

The remaining registers are extracted from the `register_data` list, so
they are ready to be passed as arguments to
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md):

``` r
bef <- register_data$bef
lmdb <- register_data$lmdb
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
  lpr = lpr,
  sysi = sysi,
  sssy = sssy,
  lab_forsker = lab_forsker,
  bef = bef,
  lmdb = lmdb
)

classified_diabetes
#> # Source:   SQL [?? x 5]
#> # Database: DuckDB 1.5.2 [unknown@Linux 6.17.0-1010-azure:R 4.5.3//tmp/Rtmp99EvMx/duckplyr/duckplyr1d6efa8855c.duckdb]
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 732715981647 2016-12-19            2016-12-19         FALSE   TRUE   
#> 2 240771768588 2016-04-04            2016-04-04         FALSE   TRUE   
#> 3 720437203185 2018-08-30            2018-08-30         FALSE   TRUE   
#> 4 409442575549 2020-05-04            2020-05-04         FALSE   TRUE   
#> 5 298944792608 2017-02-01            2017-02-01         FALSE   TRUE   
#> 6 498989088479 2014-11-09            2014-11-09         FALSE   TRUE   
#> 7 706974528463 2016-11-07            2016-11-07         FALSE   TRUE
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
#> # A tibble: 7 × 5
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 732715981647 2016-12-19            2016-12-19         FALSE   TRUE   
#> 2 409442575549 2020-05-04            2020-05-04         FALSE   TRUE   
#> 3 240771768588 2016-04-04            2016-04-04         FALSE   TRUE   
#> 4 720437203185 2018-08-30            2018-08-30         FALSE   TRUE   
#> 5 298944792608 2017-02-01            2017-02-01         FALSE   TRUE   
#> 6 498989088479 2014-11-09            2014-11-09         FALSE   TRUE   
#> 7 706974528463 2016-11-07            2016-11-07         FALSE   TRUE
```

Now, we can see that with the simulated data, 7 individuals are
classified as having diabetes.

#### Understanding the output

The output is a table with one row per classified individual and five
columns:

| Column                  | Description                                                                                                                   |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `pnr`                   | The pseudonymised personal identification number.                                                                             |
| `stable_inclusion_date` | The date of the second inclusion event, if on or after `stable_inclusion_start_date` (default: 1998). `NA` for earlier dates. |
| `raw_inclusion_date`    | The date of the second inclusion event without setting `NA` for date earlier than the `stable_inclusion_start_date`.          |
| `has_t1d`               | `TRUE` if classified as type 1 diabetes, `FALSE` otherwise.                                                                   |
| `has_t2d`               | `TRUE` if classified as type 2 diabetes, `FALSE` otherwise.                                                                   |

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

In a real-world scenario, the register data is too large to read into
memory all at once. We recommend converting your register files into
[Parquet](https://parquet.apache.org/) format on disk, with each
register in its own folder (e.g., all `lmdb` files in one folder, all
`lab_forsker` files in another, etc.).

> **Tip**
>
> To convert SAS (`.sas7bdat`) files to Parquet, you can use the
> [`fastreg`](https://dp-next.github.io/fastreg/) package.

If you’re working on Statistics Denmark’s (DST) server, be aware that
the pre-installed R packages can be quite old (for example, at the time
of writing, [`library(duckplyr)`](https://duckplyr.tidyverse.org) loads
version 0.4 of the duckplyr package from 2024, whereas the latest
version on CRAN is \>1.1 from 2026). These old versions don’t support
the dplyr operations necessary for osdc to work.

Installing osdc with `install.packages("osdc")` should force the
necessary updates of package dependencies. Otherwise, the latest version
of any given package can be installed from DST’s local CRAN mirror by
using
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html).
The downside of this approach is that you have to repeat the package
installations frequently (whenever you log on to a new virtual machine,
or after the servers weekly reset).

After making sure that you have the newest version of osdc installed
(which should install/update any necessary dependencies), you can load
each register directly from its Parquet folder and convert it to DuckDB,
as shown below.

Currently, the conversion to DuckDB requires that the user specifies
some connection parameters first:

- the maximum amount of memory to be allocated for DuckDB data, e.g.
  128GB which is stable and should be more than enough to hold the
  inputs to osdc in DuckDB
- where to temporarily store any DuckDB data that exceeds this
  threshold.

``` r
ddb_driver <- duckdb::duckdb(config = list(
  memory = "128GB",
  temp_dir = "path/to/temp/dir"
))

ddb_con <- DBI::dbConnect(ddb_driver)
```

If you’re working with very large data sets, it’s good practice to
filter the data on the Arrow side before converting to DuckDB to reduce
computation and memory use. Conveniently, most of dplyr’s filtering and
selection operations are supported by the arrow package. If you need to
rename variables or convert their types to match the inputs expected by
osdc, you can do that too:

``` r
diagnoser <- "path/to/diagnoser_parquet_folder" |>
  arrow::open_dataset(unify_schemas = TRUE) |>
  arrow::to_duckdb() |>
  # Insert dplyr filtering and variable selection/renaming steps here, e.g.:
  # dplyr::select(...) |>
  # dplyr::filter(...) |>
  arrow::to_duckdb(con = ddb_con) |>
  dplyr::compute()
```

Once you’re done using DuckDB, you should close the driver and
connection like so:

``` r
duckdb::duckdb_shutdown(ddb_driver)
DBI::dbDisconnect(ddb_con)
```

If your data is already in R (e.g., as a data frame), you can convert it
to a DuckDB table with:

``` r
diagnoser <- diagnoser |>
  arrow::to_duckdb() |>
  dplyr::compute()
```

## Getting help

If you encounter a bug or have a question about how to use osdc, please
open an issue on the [GitHub
repository](https://github.com/steno-aarhus/osdc/issues). When reporting
a bug, include a minimal example that reproduces the problem along to
help us understand and investigate the problem.
