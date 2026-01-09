# Getting started

This package serves two overarching purposes:

1.  To provide an open-source, code-based algorithm to classify type 1
    and type 2 diabetes using Danish registers as data sources.
2.  To inspire discussions within the Danish register-based research
    space on the openness and ease of use on the existing tooling and
    registers, and on the need for an official process for updating or
    contributing to existing data sources.

To read up on the overall design of this package as well as on the
algorithm, check out the
[`vignette("design")`](https://steno-aarhus.github.io/osdc/articles/design.md).
For more explanation on the motivations, rationale, and needs for this
algorithm and package, check out the
[`vignette("rationale")`](https://steno-aarhus.github.io/osdc/articles/rationale.md).
To see the specific data needed for this package and algorithm, see
[`vignette("data-sources")`](https://steno-aarhus.github.io/osdc/articles/data-sources.md).

## Usage

First, let’s load the package, as well as
[duckplyr](https://duckplyr.tidyverse.org/index.html) since we require
the data to be in the [DuckDB](https://duckdb.org/) format. See the
[`vignette("design")`](https://steno-aarhus.github.io/osdc/articles/design.md)
for some reasons why.

``` r
library(osdc)
```

The core of this package depends on the list of variables within
different registers that are needed in order to classify the diabetes
status of an individual. This can be found in the list:

``` r
# Only showing first 2
registers() |> 
  head(2)
#> $bef
#> $bef$name
#> [1] "CPR-registerets befolkningstabel"
#> 
#> $bef$start_year
#> [1] 1968
#> 
#> $bef$end_year
#> [1] NA
#> 
#> $bef$variables
#> # A tibble: 3 × 4
#>   name      danish_description         english_description             data_type
#>   <chr>     <chr>                      <chr>                           <list>   
#> 1 pnr       Pseudonymiseret cpr-nummer Pseudonymised social security … <chr [1]>
#> 2 koen      Koen                       Gender/sex                      <chr [1]>
#> 3 foed_dato Foedselsdato               Date of birth                   <chr [2]>
#> 
#> 
#> $lmdb
#> $lmdb$name
#> [1] "Laegemiddelstatistikregisteret"
#> 
#> $lmdb$start_year
#> [1] 1995
#> 
#> $lmdb$end_year
#> [1] NA
#> 
#> $lmdb$variables
#> # A tibble: 6 × 4
#>   name   danish_description                 english_description        data_type
#>   <chr>  <chr>                              <chr>                      <list>   
#> 1 pnr    Pseudonymiseret cpr-nummer         Pseudonymised social secu… <chr [1]>
#> 2 eksd   Ekspeditionsdato                   Date of purchase           <chr [2]>
#> 3 atc    ATC-kode (fuldt specificeret)      ATC code (fully specified) <chr [1]>
#> 4 volume Antal standarddoser (DDD) i pakken Number of daily standard … <chr [1]>
#> 5 apk    Antal pakker koebt                 Number of packages purcha… <chr [1]>
#> 6 indo   Indikationskode for recept         Indication code            <chr [1]>
```

We can see the list of registers we need with:

``` r
registers() |> 
  names()
#> [1] "bef"         "lmdb"        "lpr_adm"     "lpr_diag"    "kontakter"  
#> [6] "diagnoser"   "sysi"        "sssy"        "lab_forsker"
```

Let’s create a fake dataset to show how to use the classification. We
have a helper function
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md)
that takes a vector of register names and outputs a list of registers
with simulated data. Because of the way that DuckDB connections work, we
have to either load the data directly from a file as a DuckDB table, or
convert a tibble into a DuckDB table. So we’ll do that right after
simulating the data.

``` r
register_data <- registers() |> 
  names() |> 
  simulate_registers() |> 
  purrr::map(duckplyr::as_duckdb_tibble) |> 
  # Convert to a DuckDB connection, as duckplyr is still
  # in early development, while the DBI-DuckDB connection
  # is more stable.
  purrr::map(duckplyr::as_tbl) 

# Show only the first two items.
register_data |> 
  head(2)
#> $bef
#> # Source:   table<as_tbl_duckplyr_Ms0qNyXTJO> [?? x 3]
#> # Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/RtmpeiiTzJ/duckplyr/duckplyr22871227100f.duckdb]
#>     koen pnr          foed_dato
#>    <int> <chr>        <chr>    
#>  1     1 108684730664 19320112 
#>  2     2 982144017357 20070716 
#>  3     2 672580814975 19800805 
#>  4     2 439008110445 20090628 
#>  5     1 489714666740 20170225 
#>  6     1 155331797020 19730330 
#>  7     2 777951655096 19341022 
#>  8     1 167007504860 20010318 
#>  9     2 132473802596 19530901 
#> 10     1 876820784981 19310817 
#> # ℹ more rows
#> 
#> $diagnoser
#> # Source:   table<as_tbl_duckplyr_VDkIxarsMS> [?? x 4]
#> # Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/RtmpeiiTzJ/duckplyr/duckplyr22871227100f.duckdb]
#>    dw_ek_kontakt      diagnosekode diagnosetype senere_afkraeftet
#>    <chr>              <chr>        <chr>        <chr>            
#>  1 920166254345774467 DX7621       B            Nej              
#>  2 075972782062569784 DZ832        B            Ja               
#>  3 176536283003603061 DQ796        A            Nej              
#>  4 581624294965046227 DN764E       A            Nej              
#>  5 814210282344580857 DB260        B            Nej              
#>  6 393885735973313484 DM13         B            Nej              
#>  7 836179506546686729 DZ52         B            Ja               
#>  8 814175436846538799 DQ666D       B            Nej              
#>  9 508133593881487375 DK660C       A            Nej              
#> 10 325077063891132755 DT559B       B            Nej              
#> # ℹ more rows
```

Now we can run the
[`classify_diabetes()`](https://steno-aarhus.github.io/osdc/reference/classify_diabetes.md)
on the simulated data. Because we use DuckDB, in order to “materialize”
the data into R, you need to use
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html).

``` r
classified_diabetes <- classify_diabetes(
  kontakter = register_data$kontakter,
  diagnoser = register_data$diagnoser,
  lpr_diag = register_data$lpr_diag,
  lpr_adm = register_data$lpr_adm,
  sysi = register_data$sysi,
  sssy = register_data$sssy,
  lab_forsker = register_data$lab_forsker,
  bef = register_data$bef,
  lmdb = register_data$lmdb
) |> 
  dplyr::collect()

classified_diabetes
#> # A tibble: 8 × 5
#>   pnr          stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>   <chr>        <date>                <date>             <lgl>   <lgl>  
#> 1 509234825308 2018-08-30            2018-08-30         FALSE   TRUE   
#> 2 706974528463 2021-11-22            2021-11-22         FALSE   TRUE   
#> 3 732715981647 2020-08-24            2020-08-24         FALSE   TRUE   
#> 4 298944792608 2014-09-05            2014-09-05         FALSE   TRUE   
#> 5 498989088479 2020-11-26            2020-11-26         FALSE   TRUE   
#> 6 409442575549 2025-05-05            2025-05-05         FALSE   TRUE   
#> 7 240771768588 2013-01-21            2013-01-21         FALSE   TRUE   
#> 8 763443077148 2016-07-03            2016-07-03         FALSE   TRUE
```

Just by pure chance, there are 8 simulated individuals that get
classified into diabetes status. This is mainly because we’ve created
the simulated data to over-represent the values in the variables
included in the algorithm that will lead to classifying into diabetes
status.

In a real scenario, the register data is probably too big to read into
memory before being converted into a `duckdb_tibble`. Therefore, we
recommend that users first convert the individual register files into
`.parquet` format on disk, with each register source contained in
separate folders (e.g. all files from `kontakter` in one folder,
`diagnoser` in another, `lpr_diag` in a third folder etc.). With the
`arrow` package, each register data source can then be read in as a
single `duckdb_tibble` by pointing the following code snippet to each of
the Parquet folders. E.g. to load in `diagnoser`:

``` r
diagnoser <- diagnoser_parquet_folder |>
  arrow::open_dataset(unify_schemas = TRUE) |>
  arrow::to_duckdb()
```

And that’s all there is to this package! You can now save this dataset
as a Parquet file for you or your collaborators on your DST project to
use these classifications.

``` r
classified_diabetes |>
  duckplyr::as_duckdb_tibble() |>
  duckplyr::compute_parquet(
    "classified_diabetes.parquet"
  )
```
