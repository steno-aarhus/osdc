# Register variables (with descriptions) required for the osdc algorithm.

Register variables (with descriptions) required for the osdc algorithm.

## Usage

``` r
registers()
```

## Source

Many of the details within the `registers()` metadata come from the full
official list of registers from Statistics Denmark (DST):
<https://www.dst.dk/extranet/forskningvariabellister/Oversigt%20over%20registre.html>

## Value

Outputs a list of registers and variables required by osdc. Each list
item contains the official Danish name of the register, the start year,
the end year, and the variables with their descriptions. Each register
item is a list with 4 items:

- name:

  The official name of the variable found in the register.

- danish_description:

  The official Danish description of the variable.

- english_description:

  The translated English description of the variable.

- data_type:

  The data type, e.g. "character" of the variable.

## Examples

``` r
registers()
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
#>   <chr>     <chr>                      <chr>                           <chr>    
#> 1 pnr       Pseudonymiseret cpr-nummer Pseudonymised social security … character
#> 2 koen      Koen                       Gender/sex                      integer  
#> 3 foed_dato Foedselsdato               Date of birth                   Date     
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
#>   <chr>  <chr>                              <chr>                      <chr>    
#> 1 pnr    Pseudonymiseret cpr-nummer         Pseudonymised social secu… character
#> 2 eksd   Ekspeditionsdato                   Date of purchase           Date     
#> 3 atc    ATC-kode (fuldt specificeret)      ATC code (fully specified) character
#> 4 volume Antal standarddoser (DDD) i pakken Number of daily standard … numeric  
#> 5 apk    Antal pakker koebt                 Number of packages purcha… numeric  
#> 6 indo   Indikationskode for recept         Indication code            character
#> 
#> 
#> $lpr_adm
#> $lpr_adm$name
#> [1] "Landspatientregisterets administrationstabel (LPR2)"
#> 
#> $lpr_adm$start_year
#> [1] 1977
#> 
#> $lpr_adm$end_year
#> [1] 2018
#> 
#> $lpr_adm$variables
#> # A tibble: 4 × 4
#>   name     danish_description                    english_description   data_type
#>   <chr>    <chr>                                 <chr>                 <chr>    
#> 1 pnr      Pseudonymiseret cpr-nummer            Pseudonymised social… character
#> 2 recnum   Kontakt id-nummer                     Record id number      character
#> 3 d_inddto Indlaeggelsesdato (start paa kontakt) Date of admission or… Date     
#> 4 c_spec   Afdelings specialekode                Specialty code of de… character
#> 
#> 
#> $lpr_diag
#> $lpr_diag$name
#> [1] "Landspatientregisterets diagnosetabel (LPR2)"
#> 
#> $lpr_diag$start_year
#> [1] 1977
#> 
#> $lpr_diag$end_year
#> [1] 2018
#> 
#> $lpr_diag$variables
#> # A tibble: 3 × 4
#>   name       danish_description english_description data_type
#>   <chr>      <chr>              <chr>               <chr>    
#> 1 recnum     Kontakt id-nummer  Record id number    character
#> 2 c_diag     Diagnosekode       Diagnosis code      character
#> 3 c_diagtype Diagnosetype       Diagnosis type      character
#> 
#> 
#> $lpr3a_kontakt
#> $lpr3a_kontakt$name
#> [1] "Landspatientregisterets kontakttabel (LPR3A)"
#> 
#> $lpr3a_kontakt$start_year
#> [1] 2019
#> 
#> $lpr3a_kontakt$end_year
#> [1] NA
#> 
#> $lpr3a_kontakt$variables
#> # A tibble: 4 × 4
#>   name                danish_description           english_description data_type
#>   <chr>               <chr>                        <chr>               <chr>    
#> 1 pnr                 Pseudonymiseret cpr-nummer.… Pseudonymised soci… character
#> 2 dw_ek_kontakt       Kontakt id-nummer. Svarer t… Record id number. … character
#> 3 kont_starttidspunkt Indlaeggelsesdato (start pa… Date of admission … Date     
#> 4 kont_ans_hovedspec  Afdelings speciale. Ligner … Specialty of depar… character
#> 
#> 
#> $lpr3a_diagnose
#> $lpr3a_diagnose$name
#> [1] "Landspatientregisterets diagnosetabel (LPR3A)"
#> 
#> $lpr3a_diagnose$start_year
#> [1] 2019
#> 
#> $lpr3a_diagnose$end_year
#> [1] NA
#> 
#> $lpr3a_diagnose$variables
#> # A tibble: 4 × 4
#>   name              danish_description             english_description data_type
#>   <chr>             <chr>                          <chr>               <chr>    
#> 1 dw_ek_kontakt     Kontakt id-nummer. Svarer til… Record id number. … character
#> 2 diag_kode         Diagnosekode. Svarer til c_di… Diagnosis code. Eq… character
#> 3 diag_type         Diagnosetype. Svarer til c_di… Diagnosis type. Eq… character
#> 4 senere_afkraeftet Blev diagnosen senere afkraef… Was the diagnosis … character
#> 
#> 
#> $lpr3f_kontakter
#> $lpr3f_kontakter$name
#> [1] "Landspatientregisterets kontakttabel (LPR3F)"
#> 
#> $lpr3f_kontakter$start_year
#> [1] 2019
#> 
#> $lpr3f_kontakter$end_year
#> [1] NA
#> 
#> $lpr3f_kontakter$variables
#> # A tibble: 4 × 4
#>   name              danish_description             english_description data_type
#>   <chr>             <chr>                          <chr>               <chr>    
#> 1 pnr               Pseudonymiseret cpr-nummer. S… Pseudonymised soci… character
#> 2 dw_ek_kontakt     Kontakt id-nummer. Svarer til… Record id number. … character
#> 3 dato_start        Indlaeggelsesdato (start paa … Date of admission … Date     
#> 4 hovedspeciale_ans Afdelings speciale             Specialty of depar… character
#> 
#> 
#> $lpr3f_diagnoser
#> $lpr3f_diagnoser$name
#> [1] "Landspatientregisterets diagnosetabel (LPR3F)"
#> 
#> $lpr3f_diagnoser$start_year
#> [1] 2019
#> 
#> $lpr3f_diagnoser$end_year
#> [1] NA
#> 
#> $lpr3f_diagnoser$variables
#> # A tibble: 4 × 4
#>   name              danish_description             english_description data_type
#>   <chr>             <chr>                          <chr>               <chr>    
#> 1 dw_ek_kontakt     Kontakt id-nummer              Record id number    character
#> 2 diagnosekode      Diagnosekode                   Diagnosis code      character
#> 3 diagnosetype      Diagnosetype                   Diagnosis type      character
#> 4 senere_afkraeftet Blev diagnosen senere afkraef… Was the diagnosis … character
#> 
#> 
#> $sysi
#> $sysi$name
#> [1] "Sygesikringsregisteret"
#> 
#> $sysi$start_year
#> [1] 1990
#> 
#> $sysi$end_year
#> [1] 2005
#> 
#> $sysi$variables
#> # A tibble: 4 × 4
#>   name     danish_description                      english_description data_type
#>   <chr>    <chr>                                   <chr>               <chr>    
#> 1 pnr      Pseudonymiseret cpr-nummer              Pseudonymised soci… character
#> 2 barnmak  Blev ydelse ydet til patientens barn?   Was the service pr… integer  
#> 3 speciale Ydelsens honoreringskode                Billing code of th… character
#> 4 honuge   Aar og uge for ydelse (ikke-standard d… Year and week of s… character
#> 
#> 
#> $sssy
#> $sssy$name
#> [1] "Sygesikringsregisteret"
#> 
#> $sssy$start_year
#> [1] 2006
#> 
#> $sssy$end_year
#> [1] NA
#> 
#> $sssy$variables
#> # A tibble: 4 × 4
#>   name     danish_description                      english_description data_type
#>   <chr>    <chr>                                   <chr>               <chr>    
#> 1 pnr      Pseudonymiseret cpr-nummer              Pseudonymised soci… character
#> 2 barnmak  Blev ydelse ydet til patientens barn?   Was the service pr… integer  
#> 3 speciale Ydelsens honoreringskode                Billing code of th… character
#> 4 honuge   Aar og uge for ydelse (ikke-standard d… Year and week of s… character
#> 
#> 
#> $lab_forsker
#> $lab_forsker$name
#> [1] "Laboratoriedatabasens forskertabel"
#> 
#> $lab_forsker$start_year
#> [1] 2011
#> 
#> $lab_forsker$end_year
#> [1] NA
#> 
#> $lab_forsker$variables
#> # A tibble: 4 × 4
#>   name         danish_description           english_description        data_type
#>   <chr>        <chr>                        <chr>                      <chr>    
#> 1 pnr          Pseudonymiseret cpr-nummer   Pseudonymised social secu… character
#> 2 samplingdate Dato for proevetagning       Date of sampling           Date     
#> 3 analysiscode Analysens NPU-kode           NPU code of analysis       character
#> 4 value        Numerisk resultat af analyse Numerical result of analy… numeric  
#> 
#> 
```
