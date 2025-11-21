# List of non-cases to test the diabetes classification algorithm

This function generates a list of DuckDB tibbles representing the Danish
health registers and the data necessary to run the algorithm. The
dataset contains individuals who should *not* be included in the final
classified cohort.

## Usage

``` r
non_cases()
```

## Value

A named list of 9
[`duckplyr::duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.html)
objects, each representing a different health register: `bef`, `lmdb`,
`lpr_adm`, `lpr_diag`, `kontakter`, `diagnoser`, `sysi`, `sssy`, and
`lab_forsker`.

## Details

The generated data is used in `testthat` tests to ensure the algorithm
behaves as expected under a wide range of conditions, but it is also
intended to be explored by users to better understand how the algorithm
logic works and to be shown in the documentation.

## Examples

``` r
non_cases()
#> $bef
#> # A duckplyr data frame: 3 variables
#>    pnr           koen foed_dato
#>    <chr>        <int> <chr>    
#>  1 nc_pcos_1        2 19800101 
#>  2 nc_pcos_2        2 19800101 
#>  3 nc_pcos_3        2 19800101 
#>  4 nc_preg_1        2 19800101 
#>  5 nc_preg_2        2 19800101 
#>  6 nc_preg_3        2 19800101 
#>  7 nc_preg_4        2 19800101 
#>  8 164409653234     1 19230301 
#>  9 952443913885     1 19330321 
#> 10 679714832266     1 19591020 
#> # ℹ more rows
#> 
#> $diagnoser
#> # A duckplyr data frame: 4 variables
#>    dw_ek_kontakt      diagnosekode diagnosetype senere_afkraeftet
#>    <chr>              <chr>        <chr>        <chr>            
#>  1 1                  DI10         A            Nej              
#>  2 2                  DO00         A            Nej              
#>  3 3                  DZ33         A            Nej              
#>  4 942848630572354208 DZ39321P     A            Ja               
#>  5 069594786879610784 DQ447        B            Nej              
#>  6 103668538248089087 DQ438P       B            Ja               
#>  7 568625840943904921 DS78         B            Nej              
#>  8 849133686529524253 DX6701       B            Nej              
#>  9 371073944504254886 DE470        A            Nej              
#> 10 844730233259097607 DC795E       B            Nej              
#> # ℹ more rows
#> 
#> $kontakter
#> # A duckplyr data frame: 4 variables
#>    cpr          dw_ek_kontakt      hovedspeciale_ans       dato_start
#>    <chr>        <chr>              <chr>                   <chr>     
#>  1 nc_pcos_1    1                  medicinsk endokrinologi 20210101  
#>  2 nc_pcos_2    1                  medicinsk endokrinologi 20190101  
#>  3 nc_pcos_3    1                  medicinsk endokrinologi 20190101  
#>  4 nc_preg_3    1                  abc                     20200101  
#>  5 nc_preg_4    1                  abc                     20200101  
#>  6 nc_preg_3    2                  abc                     20200101  
#>  7 nc_preg_4    3                  abc                     20200101  
#>  8 164409653234 942848630572354208 Hæmatologi              20150812  
#>  9 952443913885 069594786879610784 Thoraxkirurgi           20150710  
#> 10 679714832266 103668538248089087 Reumatologi             20221028  
#> # ℹ more rows
#> 
#> $lab_forsker
#> # A duckplyr data frame: 4 variables
#>    patient_cpr  samplingdate analysiscode value
#>    <chr>        <chr>        <chr>        <dbl>
#>  1 nc_pcos_1    20210101     NPU27300     48   
#>  2 nc_pcos_2    20190101     NPU03835      6.5 
#>  3 nc_pcos_3    20190101     NPU03835      6.5 
#>  4 nc_preg_1    20170301     NPU27300     48   
#>  5 nc_preg_2    20180301     NPU03835      6.5 
#>  6 nc_preg_3    20190301     NPU03835      6.5 
#>  7 nc_preg_4    20200301     NPU27300     48   
#>  8 164409653234 20171105     NPU15168     86.4 
#>  9 952443913885 20110925     NPU86660      1.43
#> 10 679714832266 20211015     NPU81556     74.9 
#> # ℹ more rows
#> 
#> $lmdb
#> # A duckplyr data frame: 6 variables
#>    pnr          volume eksd     atc       apk indo   
#>    <chr>         <dbl> <chr>    <chr>   <dbl> <chr>  
#>  1 nc_pcos_1     10    20210101 A10BA02  5    0000276
#>  2 nc_pcos_2     10    20190101 A10BA02  5    0000276
#>  3 nc_pcos_3     10    20190101 A10BA02  5    0000276
#>  4 nc_preg_1     10    20180101 A10      5    0000000
#>  5 nc_preg_2     10    20180101 A10      5    0000000
#>  6 nc_preg_3     10    20200101 A10      5    0000000
#>  7 nc_preg_4     10    20200101 A10      5    0000000
#>  8 164409653234   9.24 20240410 B05AX03  9.30 9477070
#>  9 952443913885   3.93 20180228 L01AA01  6.80 2229609
#> 10 679714832266   3.14 20120310 S01GA05  1.94 6934228
#> # ℹ more rows
#> 
#> $lpr_adm
#> # A duckplyr data frame: 4 variables
#>    pnr          c_spec recnum             d_inddto
#>    <chr>        <chr>  <chr>              <chr>   
#>  1 nc_pcos_1    08     1                  20180101
#>  2 nc_pcos_2    08     1                  20170101
#>  3 nc_pcos_3    08     1                  20170101
#>  4 nc_preg_1    08     1                  20180101
#>  5 nc_preg_2    08     1                  20180101
#>  6 nc_preg_1    08     2                  20180101
#>  7 nc_preg_2    08     3                  20180101
#>  8 164409653234 46     942848630572354208 20150812
#>  9 952443913885 58     069594786879610784 20150710
#> 10 679714832266 54     103668538248089087 20221028
#> # ℹ more rows
#> 
#> $lpr_diag
#> # A duckplyr data frame: 3 variables
#>    recnum             c_diag c_diagtype
#>    <chr>              <chr>  <chr>     
#>  1 1                  149    A         
#>  2 2                  DO00   A         
#>  3 3                  DZ33   A         
#>  4 942848630572354208 E9511  B         
#>  5 069594786879610784 08459  B         
#>  6 103668538248089087 31502  A         
#>  7 568625840943904921 59401  B         
#>  8 849133686529524253 31154  A         
#>  9 371073944504254886 Y9001  B         
#> 10 844730233259097607 63000  A         
#> # ℹ more rows
#> 
#> $sssy
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 53       2101  
#>  2 nc_pcos_2          0 53       1901  
#>  3 nc_pcos_3          0 53       1901  
#>  4 nc_preg_1          0 53       2001  
#>  5 nc_preg_2          0 53       2001  
#>  6 nc_preg_3          0 53       2001  
#>  7 nc_preg_4          0 53       2001  
#>  8 164409653234       0 15168    2315  
#>  9 952443913885       1 86660    0523  
#> 10 679714832266       0 81556    1141  
#> # ℹ more rows
#> 
#> $sysi
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 53       2101  
#>  2 nc_pcos_2          0 53       1901  
#>  3 nc_pcos_3          0 53       1901  
#>  4 nc_preg_1          0 53       2001  
#>  5 nc_preg_2          0 53       2001  
#>  6 nc_preg_3          0 53       2001  
#>  7 nc_preg_4          0 53       2001  
#>  8 164409653234       0 15168    9023  
#>  9 952443913885       1 86660    9641  
#> 10 679714832266       0 81556    9151  
#> # ℹ more rows
#> 
```
