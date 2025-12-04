# List of non-cases to test the diabetes classification algorithm

This function generates a list of tibbles representing the Danish health
registers and the data necessary to run the algorithm. The dataset
contains individuals who should *not* be included in the final
classified cohort.

## Usage

``` r
non_cases()
```

## Value

A named list of 9
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
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
#> # A tibble: 7 × 3
#>   pnr        koen foed_dato
#>   <chr>     <int> <chr>    
#> 1 nc_pcos_1     2 19800101 
#> 2 nc_pcos_2     2 19800101 
#> 3 nc_pcos_3     2 19800101 
#> 4 nc_preg_1     2 19800101 
#> 5 nc_preg_2     2 19800101 
#> 6 nc_preg_3     2 19800101 
#> 7 nc_preg_4     2 19800101 
#> 
#> $lmdb
#> # A tibble: 7 × 6
#>   pnr       volume eksd     atc       apk indo   
#>   <chr>      <dbl> <chr>    <chr>   <dbl> <chr>  
#> 1 nc_pcos_1     10 20210101 A10BA02     5 0000276
#> 2 nc_pcos_2     10 20190101 A10BA02     5 0000276
#> 3 nc_pcos_3     10 20190101 A10BA02     5 0000276
#> 4 nc_preg_1     10 20180101 A10         5 0000000
#> 5 nc_preg_2     10 20180101 A10         5 0000000
#> 6 nc_preg_3     10 20200101 A10         5 0000000
#> 7 nc_preg_4     10 20200101 A10         5 0000000
#> 
#> $lpr_adm
#> # A tibble: 7 × 4
#>   pnr       c_spec recnum d_inddto
#>   <chr>     <chr>  <chr>  <chr>   
#> 1 nc_pcos_1 08     1      20180101
#> 2 nc_pcos_2 08     1      20170101
#> 3 nc_pcos_3 08     1      20170101
#> 4 nc_preg_1 08     1      20180101
#> 5 nc_preg_2 08     1      20180101
#> 6 nc_preg_1 08     2      20180101
#> 7 nc_preg_2 08     3      20180101
#> 
#> $lpr_diag
#> # A tibble: 3 × 3
#>   recnum c_diag c_diagtype
#>   <chr>  <chr>  <chr>     
#> 1 1      149    A         
#> 2 2      DO00   A         
#> 3 3      DZ33   A         
#> 
#> $kontakter
#> # A tibble: 7 × 4
#>   cpr       dw_ek_kontakt hovedspeciale_ans       dato_start
#>   <chr>     <chr>         <chr>                   <chr>     
#> 1 nc_pcos_1 1             medicinsk endokrinologi 20210101  
#> 2 nc_pcos_2 1             medicinsk endokrinologi 20190101  
#> 3 nc_pcos_3 1             medicinsk endokrinologi 20190101  
#> 4 nc_preg_3 1             abc                     20200101  
#> 5 nc_preg_4 1             abc                     20200101  
#> 6 nc_preg_3 2             abc                     20200101  
#> 7 nc_preg_4 3             abc                     20200101  
#> 
#> $diagnoser
#> # A tibble: 3 × 4
#>   dw_ek_kontakt diagnosekode diagnosetype senere_afkraeftet
#>   <chr>         <chr>        <chr>        <chr>            
#> 1 1             DI10         A            Nej              
#> 2 2             DO00         A            Nej              
#> 3 3             DZ33         A            Nej              
#> 
#> $sysi
#> # A tibble: 7 × 4
#>   pnr       barnmak speciale honuge
#>   <chr>       <int> <chr>    <chr> 
#> 1 nc_pcos_1       0 53       2101  
#> 2 nc_pcos_2       0 53       1901  
#> 3 nc_pcos_3       0 53       1901  
#> 4 nc_preg_1       0 53       2001  
#> 5 nc_preg_2       0 53       2001  
#> 6 nc_preg_3       0 53       2001  
#> 7 nc_preg_4       0 53       2001  
#> 
#> $sssy
#> # A tibble: 7 × 4
#>   pnr       barnmak speciale honuge
#>   <chr>       <int> <chr>    <chr> 
#> 1 nc_pcos_1       0 53       2101  
#> 2 nc_pcos_2       0 53       1901  
#> 3 nc_pcos_3       0 53       1901  
#> 4 nc_preg_1       0 53       2001  
#> 5 nc_preg_2       0 53       2001  
#> 6 nc_preg_3       0 53       2001  
#> 7 nc_preg_4       0 53       2001  
#> 
#> $lab_forsker
#> # A tibble: 7 × 4
#>   patient_cpr samplingdate analysiscode value
#>   <chr>       <chr>        <chr>        <dbl>
#> 1 nc_pcos_1   20210101     NPU27300      48  
#> 2 nc_pcos_2   20190101     NPU03835       6.5
#> 3 nc_pcos_3   20190101     NPU03835       6.5
#> 4 nc_preg_1   20170301     NPU27300      48  
#> 5 nc_preg_2   20180301     NPU03835       6.5
#> 6 nc_preg_3   20190301     NPU03835       6.5
#> 7 nc_preg_4   20200301     NPU27300      48  
#> 
```
