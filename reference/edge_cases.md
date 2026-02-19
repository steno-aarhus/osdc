# Create a synthetic dataset of edge case inputs

This function generates a list of tibbles representing the Danish health
registers and the data necessary to run the algorithm. The dataset
contains 23 individual cases (`pnr`s), each designed to test a specific
logical branch of the diabetes classification algorithm, including
inclusion, exclusion, censoring, and type classification rules.

The generated data is used in `testthat` tests to ensure the algorithm
behaves as expected under a wide range of conditions, but it is also
intended to be explored by users to better understand how the algorithm
logic works.

## Usage

``` r
edge_cases()
```

## Value

A named list of 9
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html)
objects, each representing a different health register: `bef`, `lmdb`,
`lpr_adm`, `lpr_diag`, `kontakter`, `diagnoser`, `sysi`, `sssy`, and
`lab_forsker`.

## Examples

``` r
edge_cases()
#> $bef
#> # A tibble: 23 × 3
#>    pnr                                     koen foed_dato 
#>    <chr>                                  <int> <date>    
#>  1 01_t1d_oipT_anyt1dT                        1 1980-01-01
#>  2 02_t2d_oipT_anyt1dF                        2 1981-02-03
#>  3 03_t2d_oipF_anyt1dF                        1 1975-05-10
#>  4 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T     2 1960-11-15
#>  5 05_t2d_oipF_endoT_majt1dT_i180T_itwo3F     2 1951-01-01
#>  6 06_t2d_oipF_endoT_majt1dT_i180F_itwo3T     1 1988-04-04
#>  7 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T     2 1953-06-06
#>  8 08_t1d_oipF_medT_majt1dT_i180T_itwo3T      1 1992-08-08
#>  9 09_t2d_oipF_medT_majt1dT_i180T_itwo3F      1 1993-09-09
#> 10 10_t2d_oipF_medT_majt1dT_i180F_itwo3T      1 1985-07-07
#> # ℹ 13 more rows
#> 
#> $lmdb
#> # A tibble: 55 × 6
#>    pnr                                    volume eksd       atc       apk indo  
#>    <chr>                                   <dbl> <date>     <chr>   <dbl> <chr> 
#>  1 01_t1d_oipT_anyt1dT                        10 2020-01-10 A10AB01     5 12345…
#>  2 01_t1d_oipT_anyt1dT                        10 2020-04-10 A10AE01     5 12345…
#>  3 02_t2d_oipT_anyt1dF                        10 2011-02-20 A10AB01     5 23456…
#>  4 02_t2d_oipT_anyt1dF                        10 2021-05-20 A10AE01     5 23456…
#>  5 03_t2d_oipF_anyt1dF                        10 2018-01-01 A10BA02     3 34567…
#>  6 03_t2d_oipF_anyt1dF                        10 2019-03-01 A10AB01     3 34567…
#>  7 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T     10 1998-01-01 A10BA02     8 45678…
#>  8 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T     10 2022-01-01 A10BA02     2 45678…
#>  9 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T     10 2022-03-01 A10AB01     8 45678…
#> 10 05_t2d_oipF_endoT_majt1dT_i180T_itwo3F     10 2022-01-01 A10BA02     5 56789…
#> # ℹ 45 more rows
#> 
#> $lpr_adm
#> # A tibble: 21 × 4
#>    pnr                                    c_spec recnum      d_inddto  
#>    <chr>                                  <chr>  <chr>       <date>    
#>  1 01_t1d_oipT_anyt1dT                    08     pnr01_rec01 2011-05-15
#>  2 02_t2d_oipT_anyt1dF                    08     pnr02_rec01 2012-06-16
#>  3 03_t2d_oipF_anyt1dF                    34     pnr03_rec01 2010-07-17
#>  4 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T 08     pnr04_rec01 1992-01-20
#>  5 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T 08     pnr04_rec02 2013-01-20
#>  6 05_t2d_oipF_endoT_majt1dT_i180T_itwo3F 08     pnr05_rec01 2013-02-21
#>  7 06_t2d_oipF_endoT_majt1dT_i180F_itwo3T 08     pnr06_rec01 2013-03-22
#>  8 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T 08     pnr07_rec01 2012-04-23
#>  9 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T 02     pnr07_rec02 2013-04-23
#> 10 08_t1d_oipF_medT_majt1dT_i180T_itwo3T  01     pnr08_rec01 1992-01-20
#> # ℹ 11 more rows
#> 
#> $lpr_diag
#> # A tibble: 29 × 3
#>    recnum      c_diag c_diagtype
#>    <chr>       <chr>  <chr>     
#>  1 pnr01_rec01 DE111  A         
#>  2 pnr02_rec01 DE110  A         
#>  3 pnr03_rec01 DE101  A         
#>  4 pnr04_rec01 24901  A         
#>  5 pnr04_rec02 DE105  A         
#>  6 pnr04_rec02 DE114  B         
#>  7 pnr05_rec01 250    A         
#>  8 pnr06_rec01 DE103  A         
#>  9 pnr07_rec01 DE115  A         
#> 10 pnr07_rec01 DE105  B         
#> # ℹ 19 more rows
#> 
#> $kontakter
#> # A tibble: 20 × 4
#>    cpr                                dw_ek_kontakt hovedspeciale_ans dato_start
#>    <chr>                              <chr>         <chr>             <date>    
#>  1 01_t1d_oipT_anyt1dT                pnr01_dw01    medicinsk endokr… 2021-05-15
#>  2 02_t2d_oipT_anyt1dF                pnr02_dw01    thoraxkirurgi     2022-06-16
#>  3 03_t2d_oipF_anyt1dF                pnr03_dw01    kardiologi        2020-07-17
#>  4 04_t1d_oipF_endoT_majt1dT_i180T_i… pnr04_dw01    medicinsk endokr… 2023-01-20
#>  5 05_t2d_oipF_endoT_majt1dT_i180T_i… pnr05_dw01    medicinsk endokr… 2023-02-21
#>  6 06_t2d_oipF_endoT_majt1dT_i180F_i… pnr06_dw01    medicinsk endokr… 2023-03-22
#>  7 07_t2d_oipF_endoT_majt1dF_i180T_i… pnr07_dw01    medicinsk endokr… 2022-04-23
#>  8 07_t2d_oipF_endoT_majt1dF_i180T_i… pnr07_dw02    geriatri          2023-04-23
#>  9 08_t1d_oipF_medT_majt1dT_i180T_it… pnr08_dw01    kardiologi        2023-01-20
#> 10 08_t1d_oipF_medT_majt1dT_i180T_it… pnr08_dw02    kardiologi        2024-01-20
#> 11 09_t2d_oipF_medT_majt1dT_i180T_it… pnr09_dw01    kardiologi        2024-02-21
#> 12 10_t2d_oipF_medT_majt1dT_i180F_it… pnr10_dw01    kardiologi        2024-03-22
#> 13 11_t2d_oipF_medT_majt1dF_i180T_it… pnr11_dw01    kardiologi        2023-04-23
#> 14 11_t2d_oipF_medT_majt1dF_i180T_it… pnr11_dw02    medicinsk endokr… 2024-04-23
#> 15 11_t2d_oipF_medT_majt1dF_i180T_it… pnr11_dw03    thoraxkirurgi     2024-06-16
#> 16 12_nodm_gldF_diagF_hba1cF_podF     pnr12_dw01    kardiologi        2021-04-23
#> 17 14_t2d_gldF_diagF_hba1cT_podF      pnr14_dw01    gynaekologi og o… 2024-01-01
#> 18 15_t2d_gldF_diagT_hba1cF_podF      pnr15_dw01    urologi           2023-01-01
#> 19 16_t2d_gldT_diagF_hba1cF_podF      pnr16_dw01    gynaekologi og o… 2024-01-01
#> 20 21_nodm_female_pregnancyT          pnr21_dw01    gynaekologi og o… 2024-01-01
#> 
#> $diagnoser
#> # A tibble: 29 × 4
#>    dw_ek_kontakt diagnosekode diagnosetype senere_afkraeftet
#>    <chr>         <chr>        <chr>        <chr>            
#>  1 pnr01_dw01    DE101        A            Nej              
#>  2 pnr02_dw01    DE102        A            Nej              
#>  3 pnr03_dw01    DE103        A            Nej              
#>  4 pnr04_dw01    DE104        A            Nej              
#>  5 pnr04_dw02    DE115        B            Nej              
#>  6 pnr04_dw02    DE119        B            Nej              
#>  7 pnr05_dw01    DE101        A            Nej              
#>  8 pnr06_dw01    DE102        A            Nej              
#>  9 pnr07_dw01    DE103        A            Nej              
#> 10 pnr07_dw01    DE109        B            Nej              
#> # ℹ 19 more rows
#> 
#> $sysi
#> # A tibble: 20 × 4
#>    pnr                                    barnmak speciale honuge
#>    <chr>                                    <int> <chr>    <chr> 
#>  1 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T       0 54002    0453  
#>  2 06_t2d_oipF_endoT_majt1dT_i180F_itwo3T       0 67148    9924  
#>  3 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T       0 62545    9727  
#>  4 08_t1d_oipF_medT_majt1dT_i180T_itwo3T        0 20866    9632  
#>  5 09_t2d_oipF_medT_majt1dT_i180T_itwo3F        0 27002    0213  
#>  6 10_t2d_oipF_medT_majt1dT_i180F_itwo3T        0 53825    9419  
#>  7 11_t2d_oipF_medT_majt1dF_i180T_itwo3T        0 12345    1234  
#>  8 12_nodm_gldF_diagF_hba1cF_podF               0 10001    1001  
#>  9 12_nodm_gldF_diagF_hba1cF_podF               1 54002    1001  
#> 10 12_nodm_gldF_diagF_hba1cF_podF               0 10001    1002  
#> 11 12_nodm_gldF_diagF_hba1cF_podF               1 54002    1002  
#> 12 13_t2d_gldF_diagF_hba1cF_podT                0 54002    0452  
#> 13 14_t2d_gldF_diagF_hba1cT_podF                0 10003    1003  
#> 14 15_t2d_gldF_diagT_hba1cF_podF                0 10004    1004  
#> 15 16_t2d_gldT_diagF_hba1cF_podF                0 10005    1005  
#> 16 17_nodm_glp1a_dapa_empa                      0 10006    1006  
#> 17 18_t2d_male_pcosF                            0 10007    1007  
#> 18 19_nodm_female_u40_pcosT                     0 10008    1008  
#> 19 20_nodm_female_o40_pcosT                     0 10009    1009  
#> 20 21_nodm_female_pregnancyT                    0 10010    1010  
#> 
#> $sssy
#> # A tibble: 18 × 4
#>    pnr                                    barnmak speciale honuge
#>    <chr>                                    <int> <chr>    <chr> 
#>  1 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T       0 86409    2421  
#>  2 05_t2d_oipF_endoT_majt1dT_i180T_itwo3F       0 54003    1103  
#>  3 06_t2d_oipF_endoT_majt1dT_i180F_itwo3T       0 67148    0714  
#>  4 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T       0 62545    2221  
#>  5 08_t1d_oipF_medT_majt1dT_i180T_itwo3T        0 20866    1425  
#>  6 09_t2d_oipF_medT_majt1dT_i180T_itwo3F        0 27002    2237  
#>  7 10_t2d_oipF_medT_majt1dT_i180F_itwo3T        0 53825    1227  
#>  8 11_t2d_oipF_medT_majt1dF_i180T_itwo3T        0 12345    1234  
#>  9 12_nodm_gldF_diagF_hba1cF_podF               0 20001    2001  
#> 10 13_t2d_gldF_diagF_hba1cF_podT                0 54001    0801  
#> 11 14_t2d_gldF_diagF_hba1cT_podF                0 20002    2004  
#> 12 15_t2d_gldF_diagT_hba1cF_podF                0 20003    2005  
#> 13 16_t2d_gldT_diagF_hba1cF_podF                0 20004    2006  
#> 14 17_nodm_glp1a_dapa_empa                      0 20005    2007  
#> 15 18_t2d_male_pcosF                            0 20006    2008  
#> 16 19_nodm_female_u40_pcosT                     0 20007    2009  
#> 17 20_nodm_female_o40_pcosT                     0 20008    2010  
#> 18 21_nodm_female_pregnancyT                    0 20009    2011  
#> 
#> $lab_forsker
#> # A tibble: 24 × 4
#>    patient_cpr                            samplingdate analysiscode value
#>    <chr>                                  <date>       <chr>        <dbl>
#>  1 01_t1d_oipT_anyt1dT                    2019-01-01   NPU27300        50
#>  2 02_t2d_oipT_anyt1dF                    2019-01-02   NPU27300        51
#>  3 03_t2d_oipF_anyt1dF                    2019-01-01   NPU27300        52
#>  4 04_t1d_oipF_endoT_majt1dT_i180T_itwo3T 2019-01-01   NPU27300        53
#>  5 05_t2d_oipF_endoT_majt1dT_i180T_itwo3F 2019-01-01   NPU27300        54
#>  6 06_t2d_oipF_endoT_majt1dT_i180F_itwo3T 2019-01-01   NPU27300        55
#>  7 07_t2d_oipF_endoT_majt1dF_i180T_itwo3T 2019-01-01   NPU27300        56
#>  8 08_t1d_oipF_medT_majt1dT_i180T_itwo3T  2019-01-01   NPU27300        57
#>  9 09_t2d_oipF_medT_majt1dT_i180T_itwo3F  2019-01-01   NPU27300        58
#> 10 10_t2d_oipF_medT_majt1dT_i180F_itwo3T  2019-01-01   NPU27300        59
#> # ℹ 14 more rows
#> 
#> $classified
#> # A tibble: 17 × 5
#>    pnr                  stable_inclusion_date raw_inclusion_date has_t1d has_t2d
#>    <chr>                <date>                <date>             <lgl>   <lgl>  
#>  1 01_t1d_oipT_anyt1dT  2019-01-01            2019-01-01         TRUE    FALSE  
#>  2 02_t2d_oipT_anyt1dF  2012-06-16            2012-06-16         FALSE   TRUE   
#>  3 03_t2d_oipF_anyt1dF  2018-01-01            2018-01-01         FALSE   TRUE   
#>  4 04_t1d_oipF_endoT_m… 2004-12-27            2004-12-27         TRUE    FALSE  
#>  5 05_t2d_oipF_endoT_m… 2013-02-21            2013-02-21         FALSE   TRUE   
#>  6 06_t2d_oipF_endoT_m… 2019-01-01            2019-01-01         FALSE   TRUE   
#>  7 07_t2d_oipF_endoT_m… 2012-04-23            2012-04-23         FALSE   TRUE   
#>  8 08_t1d_oipF_medT_ma… 2014-01-20            2014-01-20         TRUE    FALSE  
#>  9 09_t2d_oipF_medT_ma… 2019-01-01            2019-01-01         FALSE   TRUE   
#> 10 10_t2d_oipF_medT_ma… 2019-01-01            2019-01-01         FALSE   TRUE   
#> 11 11_t2d_oipF_medT_ma… 2000-04-23            2000-04-23         FALSE   TRUE   
#> 12 13_t2d_gldF_diagF_h… 2007-12-31            2007-12-31         FALSE   TRUE   
#> 13 14_t2d_gldF_diagF_h… 2013-04-01            2013-04-01         FALSE   TRUE   
#> 14 15_t2d_gldF_diagT_h… 2023-01-01            2023-01-01         FALSE   TRUE   
#> 15 16_t2d_gldT_diagF_h… 2013-04-01            2013-04-01         FALSE   TRUE   
#> 16 18_t2d_male_pcosF    2023-04-01            2023-04-01         FALSE   TRUE   
#> 17 23_t2d_gldT_1995_19… NA                    1995-06-16         FALSE   TRUE   
#> 
```
