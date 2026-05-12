# Join prepared registers

Join prepared registers

## Usage

``` r
join_registers(register_list)
```

## Arguments

- register_list:

  A list of the prepared registers, from e.g.
  [`prepare_lpr2()`](https://steno-aarhus.github.io/osdc/reference/prepare_lpr2.md).

## Value

A single object with all rows from each register in `register_list`.

## Examples

``` r
register_data <- simulate_registers(c(
  "lpr_adm",
  "lpr_diag",
  "lpr3f_kontakter",
  "lpr3f_diagnoser",
  "sssy",
  "sysi"
))
join_registers(list(
  prepare_lpr2(register_data$lpr_adm, register_data$lpr_diag),
  prepare_lpr3f(
    register_data$lpr3f_kontakter,
    register_data$lpr3f_diagnoser
  )
))
#> # A tibble: 12 × 9
#>    pnr          date       is_primary_diagnosis is_diabetes_code is_t1d_code
#>    <chr>        <date>     <lgl>                <lgl>            <lgl>      
#>  1 466460062483 1989-04-21 FALSE                TRUE             TRUE       
#>  2 976025036207 2019-06-01 FALSE                TRUE             FALSE      
#>  3 481308509913 2008-03-04 FALSE                TRUE             FALSE      
#>  4 736038118634 1997-09-22 TRUE                 FALSE            FALSE      
#>  5 751256871567 2025-09-21 FALSE                FALSE            FALSE      
#>  6 374324771385 2017-12-21 FALSE                TRUE             FALSE      
#>  7 600867655198 1983-03-03 FALSE                FALSE            FALSE      
#>  8 237592816990 2024-09-28 TRUE                 FALSE            FALSE      
#>  9 254251768597 1995-05-31 FALSE                TRUE             TRUE       
#> 10 298722067346 2024-10-06 TRUE                 FALSE            FALSE      
#> 11 863502458498 2023-10-01 FALSE                FALSE            FALSE      
#> 12 752896932129 2006-11-24 TRUE                 FALSE            FALSE      
#> # ℹ 4 more variables: is_t2d_code <lgl>, is_endocrinology_dept <lgl>,
#> #   is_medical_dept <lgl>, is_pregnancy_code <lgl>
join_registers(list(register_data$sysi, register_data$sssy))
#> # A tibble: 2,000 × 4
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
#> # ℹ 1,990 more rows
```
