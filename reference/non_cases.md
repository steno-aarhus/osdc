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
#>  4 108684730664     1 19320112 
#>  5 982144017357     2 20070716 
#>  6 672580814975     1 19800805 
#>  7 439008110445     2 20090628 
#>  8 489714666740     1 20170225 
#>  9 155331797020     2 19730330 
#> 10 777951655096     1 19341022 
#> # ℹ more rows
#> 
#> $lmdb
#> # A duckplyr data frame: 6 variables
#>    pnr          volume eksd     atc       apk indo   
#>    <chr>         <dbl> <chr>    <chr>   <dbl> <chr>  
#>  1 nc_pcos_1     10    20210101 A10BA02  5    0000276
#>  2 nc_pcos_2     10    20190101 A10BA02  5    0000276
#>  3 nc_pcos_3     10    20190101 A10BA02  5    0000276
#>  4 108684730664   6.96 20001009 A02AB06  4.07 9175383
#>  5 982144017357   7.47 20160925 A10BJ06  5.91 2142991
#>  6 672580814975   9.80 20121027 A10BJ06  5.30 6263203
#>  7 439008110445   6.33 20110417 A10BJ06  5.20 1958385
#>  8 489714666740   6.40 20240528 C08CA01  9.99 9269216
#>  9 155331797020   9.53 20050827 N06AA12  4.14 5353152
#> 10 777951655096   5.41 20141010 N02AX03  1.61 7558017
#> # ℹ more rows
#> 
#> $lpr_adm
#> # A duckplyr data frame: 4 variables
#>    pnr          c_spec recnum             d_inddto
#>    <chr>        <chr>  <chr>              <chr>   
#>  1 nc_pcos_1    08     1                  20180101
#>  2 nc_pcos_2    08     1                  20170101
#>  3 nc_pcos_3    08     1                  20170101
#>  4 108684730664 42     920166254345774467 20170316
#>  5 982144017357 59     075972782062569784 20081030
#>  6 672580814975 59     176536283003603061 19781226
#>  7 439008110445 70     581624294965046227 20040706
#>  8 489714666740 06     814210282344580857 20160613
#>  9 155331797020 06     393885735973313484 20001231
#> 10 777951655096 88     836179506546686729 20250325
#> # ℹ more rows
#> 
#> $lpr_diag
#> # A duckplyr data frame: 3 variables
#>    recnum             c_diag c_diagtype
#>    <chr>              <chr>  <chr>     
#>  1 1                  249    A         
#>  2 920166254345774467 32208  A         
#>  3 075972782062569784 55389  B         
#>  4 176536283003603061 17309  B         
#>  5 581624294965046227 E9230  A         
#>  6 814210282344580857 E9689  B         
#>  7 393885735973313484 51122  B         
#>  8 836179506546686729 E8127  A         
#>  9 814175436846538799 23999  B         
#> 10 508133593881487375 76643  B         
#> # ℹ more rows
#> 
#> $kontakter
#> # A duckplyr data frame: 4 variables
#>    cpr          dw_ek_kontakt      hovedspeciale_ans          dato_start
#>    <chr>        <chr>              <chr>                      <chr>     
#>  1 nc_pcos_1    1                  medicinsk endokrinologi    20210101  
#>  2 nc_pcos_2    1                  medicinsk endokrinologi    20190101  
#>  3 nc_pcos_3    1                  medicinsk endokrinologi    20190101  
#>  4 108684730664 920166254345774467 Ikke klassificeret         20170316  
#>  5 982144017357 075972782062569784 Diagnostisk radiologi      20081030  
#>  6 672580814975 176536283003603061 Thoraxkirurgi              19781226  
#>  7 439008110445 581624294965046227 Klinisk neurofysiologi     20040706  
#>  8 489714666740 814210282344580857 Medicinsk gastroenterologi 20160613  
#>  9 155331797020 393885735973313484 Miljømedicin               20001231  
#> 10 777951655096 836179506546686729 Arbejdsmedicin             20250325  
#> # ℹ more rows
#> 
#> $diagnoser
#> # A duckplyr data frame: 4 variables
#>    dw_ek_kontakt      diagnosekode diagnosetype senere_afkraeftet
#>    <chr>              <chr>        <chr>        <chr>            
#>  1 1                  DE10         A            Nej              
#>  2 920166254345774467 DX7621       B            Nej              
#>  3 075972782062569784 DZ832        B            Ja               
#>  4 176536283003603061 DQ796        A            Nej              
#>  5 581624294965046227 DN764E       A            Nej              
#>  6 814210282344580857 DB260        B            Nej              
#>  7 393885735973313484 DM13         B            Nej              
#>  8 836179506546686729 DZ52         B            Ja               
#>  9 814175436846538799 DQ666D       B            Nej              
#> 10 508133593881487375 DK660C       A            Nej              
#> # ℹ more rows
#> 
#> $sysi
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 54       2101  
#>  2 nc_pcos_2          0 54       1901  
#>  3 nc_pcos_3          0 54       1901  
#>  4 108684730664       0 10022    9329  
#>  5 982144017357       0 88475    0442  
#>  6 672580814975       0 83575    9549  
#>  7 439008110445       1 86409    9603  
#>  8 489714666740       0 42818    9215  
#>  9 155331797020       0 67148    9924  
#> 10 777951655096       0 62545    9727  
#> # ℹ more rows
#> 
#> $sssy
#> # A duckplyr data frame: 4 variables
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 nc_pcos_1          0 54       2101  
#>  2 nc_pcos_2          0 54       1901  
#>  3 nc_pcos_3          0 54       1901  
#>  4 108684730664       0 10022    0830  
#>  5 982144017357       0 88475    1942  
#>  6 672580814975       0 83575    1049  
#>  7 439008110445       1 86409    2421  
#>  8 489714666740       0 42818    1103  
#>  9 155331797020       0 67148    0714  
#> 10 777951655096       0 62545    2221  
#> # ℹ more rows
#> 
#> $lab_forsker
#> # A duckplyr data frame: 4 variables
#>    patient_cpr  samplingdate analysiscode value
#>    <chr>        <chr>        <chr>        <dbl>
#>  1 nc_pcos_1    20210101     NPU27300      48  
#>  2 nc_pcos_2    20190101     NPU03835       6.5
#>  3 nc_pcos_3    20190101     NPU03835       6.5
#>  4 108684730664 20200807     NPU27300     139. 
#>  5 982144017357 20161009     NPU88475     128. 
#>  6 672580814975 20200306     NPU03835      29.3
#>  7 439008110445 20171223     NPU03835      42.7
#>  8 489714666740 20250124     NPU42818     164. 
#>  9 155331797020 20240422     NPU67148      70.4
#> 10 777951655096 20210827     NPU62545      18.4
#> # ℹ more rows
#> 
```
