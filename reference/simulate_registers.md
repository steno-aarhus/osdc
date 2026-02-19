# Simulate a fake data frame of one or more Danish registers

Simulate a fake data frame of one or more Danish registers

## Usage

``` r
simulate_registers(registers, n = 1000)
```

## Arguments

- registers:

  The name of the register you want to simulate.

- n:

  The number of rows to simulate for the resulting register.

## Value

A list with simulated register data, as a
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

## Examples

``` r
simulate_registers(c("bef", "sysi"))
#> $bef
#> # A tibble: 1,000 × 3
#>     koen pnr          foed_dato 
#>    <int> <chr>        <date>    
#>  1     2 108684730664 1932-01-12
#>  2     1 982144017357 2007-07-16
#>  3     2 672580814975 1980-08-05
#>  4     1 439008110445 2009-06-28
#>  5     2 489714666740 2017-02-25
#>  6     2 155331797020 1973-03-30
#>  7     1 777951655096 1934-10-22
#>  8     2 167007504860 2001-03-18
#>  9     2 132473802596 1953-09-01
#> 10     1 876820784981 1931-08-17
#> # ℹ 990 more rows
#> 
#> $sysi
#> # A tibble: 1,000 × 4
#>    pnr          barnmak speciale honuge
#>    <chr>          <int> <chr>    <chr> 
#>  1 108684730664       0 10022    9329  
#>  2 982144017357       0 88475    0442  
#>  3 672580814975       0 83575    9549  
#>  4 439008110445       1 86409    9603  
#>  5 489714666740       0 42818    9215  
#>  6 155331797020       0 67148    9924  
#>  7 777951655096       0 62545    9727  
#>  8 167007504860       1 20866    9632  
#>  9 132473802596       0 27002    0213  
#> 10 876820784981       0 53825    9419  
#> # ℹ 990 more rows
#> 
simulate_registers("bef")
#> $bef
#> # A tibble: 1,000 × 3
#>     koen pnr          foed_dato 
#>    <int> <chr>        <date>    
#>  1     1 108684730664 1932-01-12
#>  2     1 982144017357 2007-07-16
#>  3     1 672580814975 1980-08-05
#>  4     1 439008110445 2009-06-28
#>  5     2 489714666740 2017-02-25
#>  6     1 155331797020 1973-03-30
#>  7     2 777951655096 1934-10-22
#>  8     1 167007504860 2001-03-18
#>  9     1 132473802596 1953-09-01
#> 10     1 876820784981 1931-08-17
#> # ℹ 990 more rows
#> 
simulate_registers("diagnoser")
#> $diagnoser
#> # A tibble: 1,000 × 4
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
#> # ℹ 990 more rows
#> 
```
