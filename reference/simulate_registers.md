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

A list with simulated register data.

## Examples

``` r
simulate_registers(c("bef", "sysi"))
#> $bef
#> # A tibble: 1,000 × 3
#>     koen pnr          foed_dato
#>    <int> <chr>        <chr>    
#>  1     2 108684730664 19320112 
#>  2     1 982144017357 20070716 
#>  3     2 672580814975 19800805 
#>  4     2 439008110445 20090628 
#>  5     2 489714666740 20170225 
#>  6     1 155331797020 19730330 
#>  7     1 777951655096 19341022 
#>  8     1 167007504860 20010318 
#>  9     1 132473802596 19530901 
#> 10     2 876820784981 19310817 
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
#>    <int> <chr>        <chr>    
#>  1     1 108684730664 19320112 
#>  2     1 982144017357 20070716 
#>  3     1 672580814975 19800805 
#>  4     1 439008110445 20090628 
#>  5     2 489714666740 20170225 
#>  6     1 155331797020 19730330 
#>  7     2 777951655096 19341022 
#>  8     1 167007504860 20010318 
#>  9     1 132473802596 19530901 
#> 10     1 876820784981 19310817 
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
