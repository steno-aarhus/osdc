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
#> # A duckplyr data frame: 3 variables
#>    pnr           koen foed_dato
#>    <chr>        <int> <chr>    
#>  1 nc_pcos_1        2 19800101 
#>  2 nc_pcos_2        2 19800101 
#>  3 nc_pcos_3        2 19800101 
#>  4 164409653234     1 19230301 
#>  5 952443913885     2 19330321 
#>  6 679714832266     1 19591020 
#>  7 447393958677     2 19391013 
#>  8 447559464315     1 20220110 
#>  9 120172052967     2 20161207 
#> 10 799747754606     1 19150828 
#> # ℹ more rows
#> 
#> $diagnoser
#> # A duckplyr data frame: 4 variables
#>    dw_ek_kontakt      diagnosekode diagnosetype senere_afkraeftet
#>    <chr>              <chr>        <chr>        <chr>            
#>  1 1                  DE10         A            Nej              
#>  2 942848630572354208 DZ39321P     A            Ja               
#>  3 069594786879610784 DQ447        B            Nej              
#>  4 103668538248089087 DQ438P       B            Ja               
#>  5 568625840943904921 DS78         B            Nej              
#>  6 849133686529524253 DX6701       B            Nej              
#>  7 371073944504254886 DE470        A            Nej              
#>  8 844730233259097607 DC795E       B            Nej              
#>  9 843717711171063070 NA           B            Ja               
#> 10 588123257073986274 DO431F       A            Ja               
#> # ℹ more rows
#> 
#> $kontakter
#> # A duckplyr data frame: 4 variables
#>    cpr          dw_ek_kontakt      hovedspeciale_ans          dato_start
#>    <chr>        <chr>              <chr>                      <chr>     
#>  1 nc_pcos_1    1                  medicinsk endokrinologi    20210101  
#>  2 nc_pcos_2    1                  medicinsk endokrinologi    20190101  
#>  3 nc_pcos_3    1                  medicinsk endokrinologi    20190101  
#>  4 164409653234 942848630572354208 Retsmedicin                20150812  
#>  5 952443913885 069594786879610784 Gynækologi og obstetrik    20150710  
#>  6 679714832266 103668538248089087 Oto-, rhino-, laryngologi  20221028  
#>  7 447393958677 568625840943904921 Retsmedicin                19860306  
#>  8 447559464315 849133686529524253 Fysiurgi                   19811226  
#>  9 120172052967 371073944504254886 Anæstesiologi              20050411  
#> 10 799747754606 844730233259097607 Medicinsk gastroenterologi 20101216  
#> # ℹ more rows
#> 
#> $lab_forsker
#> # A duckplyr data frame: 4 variables
#>    patient_cpr  samplingdate analysiscode  value
#>    <chr>        <chr>        <chr>         <dbl>
#>  1 nc_pcos_1    20210101     NPU27300      48   
#>  2 nc_pcos_2    20190101     NPU03835       6.5 
#>  3 nc_pcos_3    20190101     NPU03835       6.5 
#>  4 164409653234 20171105     NPU15168      86.4 
#>  5 952443913885 20110925     NPU86660       1.43
#>  6 679714832266 20211015     NPU81556      74.9 
#>  7 447393958677 20221206     NPU86536     111.  
#>  8 447559464315 20111221     NPU44101      70.1 
#>  9 120172052967 20201118     NPU27300      43.9 
#> 10 799747754606 20151016     NPU66499      98.3 
#> # ℹ more rows
#> 
#> $lmdb
#> # A duckplyr data frame: 6 variables
#>    pnr          volume eksd     atc       apk indo   
#>    <chr>         <dbl> <chr>    <chr>   <dbl> <chr>  
#>  1 nc_pcos_1     10    20210101 A10BA02  5    0000276
#>  2 nc_pcos_2     10    20190101 A10BA02  5    0000276
#>  3 nc_pcos_3     10    20190101 A10BA02  5    0000276
#>  4 164409653234   9.24 20240410 B05AX03  9.30 9477070
#>  5 952443913885   3.93 20180228 L01AA01  6.80 2229609
#>  6 679714832266   3.14 20120310 S01GA05  1.94 6934228
#>  7 447393958677   2.63 20061206 N07BC04  6.61 1191638
#>  8 447559464315   9.40 20091210 J01CA01  3.08 9952940
#>  9 120172052967   8.56 19951221 P01AA05  8.82 5706312
#> 10 799747754606   3.62 20140809 A10AB02  6.16 7603682
#> # ℹ more rows
#> 
#> $lpr_adm
#> # A duckplyr data frame: 4 variables
#>    pnr          c_spec recnum             d_inddto
#>    <chr>        <chr>  <chr>              <chr>   
#>  1 nc_pcos_1    08     1                  20180101
#>  2 nc_pcos_2    08     1                  20170101
#>  3 nc_pcos_3    08     1                  20170101
#>  4 164409653234 46     942848630572354208 20150812
#>  5 952443913885 58     069594786879610784 20150710
#>  6 679714832266 54     103668538248089087 20221028
#>  7 447393958677 72     568625840943904921 19860306
#>  8 447559464315 08     849133686529524253 19811226
#>  9 120172052967 08     371073944504254886 20050411
#> 10 799747754606 82     844730233259097607 20101216
#> # ℹ more rows
#> 
#> $lpr_diag
#> # A duckplyr data frame: 3 variables
#>    recnum             c_diag c_diagtype
#>    <chr>              <chr>  <chr>     
#>  1 1                  249    A         
#>  2 942848630572354208 E9511  A         
#>  3 069594786879610784 08459  B         
#>  4 103668538248089087 31502  B         
#>  5 568625840943904921 59401  B         
#>  6 849133686529524253 31154  A         
#>  7 371073944504254886 Y9001  B         
#>  8 844730233259097607 63000  B         
#>  9 843717711171063070 07949  B         
#> 10 588123257073986274 94283  A         
#> # ℹ more rows
#> 
#> $sssy
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 54       2101  
#>  2 nc_pcos_2          0 54       1901  
#>  3 nc_pcos_3          0 54       1901  
#>  4 164409653234       0 15168    2315  
#>  5 952443913885       1 86660    0523  
#>  6 679714832266       0 81556    1141  
#>  7 447393958677       0 86536    2543  
#>  8 447559464315       0 44101    0651  
#>  9 120172052967       0 60312    2530  
#> 10 799747754606       0 66499    1243  
#> # ℹ more rows
#> 
#> $sysi
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 54       2101  
#>  2 nc_pcos_2          0 54       1901  
#>  3 nc_pcos_3          0 54       1901  
#>  4 164409653234       0 15168    9023  
#>  5 952443913885       1 86660    9641  
#>  6 679714832266       0 81556    9151  
#>  7 447393958677       0 86536    9743  
#>  8 447559464315       0 44101    0433  
#>  9 120172052967       0 60312    9838  
#> 10 799747754606       0 66499    9326  
#> # ℹ more rows
#> 
```
