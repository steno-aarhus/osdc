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
the end year, and the variables with their descriptions. The variables
item is a data frame with 4 columns:

- name:

  The official name of the variable found in the register.

- danish_description:

  The official Danish description of the variable.

- english_description:

  The translated English description of the variable.

- data_type:

  The data type, e.g. "character" of the variable. Could have multiple
  options (e.g. "Date" or "character").

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
#>   <chr>    <chr>                                 <chr>                 <list>   
#> 1 pnr      Pseudonymiseret cpr-nummer            Pseudonymised social… <chr [1]>
#> 2 recnum   Kontakt id-nummer                     Record id number      <chr [1]>
#> 3 d_inddto Indlaeggelsesdato (start paa kontakt) Date of admission or… <chr [2]>
#> 4 c_spec   Afdelings specialekode                Specialty code of de… <chr [1]>
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
#> $kontakter
#> $kontakter$name
#> [1] "Landspatientregisterets kontakttabel (LPR3)"
#> 
#> $kontakter$start_year
#> [1] 2019
#> 
#> $kontakter$end_year
#> [1] NA
#> 
#> $kontakter$variables
#> # A tibble: 4 × 4
#>   name              danish_description             english_description data_type
#>   <chr>             <chr>                          <chr>               <list>   
#> 1 cpr               Pseudonymiseret cpr-nummer     Pseudonymised soci… <chr [1]>
#> 2 dw_ek_kontakt     Kontakt id-nummer              Record id number    <chr [1]>
#> 3 dato_start        Indlaeggelsesdato (start paa … Date of admission … <chr [2]>
#> 4 hovedspeciale_ans Afdelings speciale             Specialty of depar… <chr [1]>
#> 
#> 
#> $diagnoser
#> $diagnoser$name
#> [1] "Landspatientregisterets diagnosetabel (LPR3)"
#> 
#> $diagnoser$start_year
#> [1] 2019
#> 
#> $diagnoser$end_year
#> [1] NA
#> 
#> $diagnoser$variables
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
#>   name     danish_description                    english_description   data_type
#>   <chr>    <chr>                                 <chr>                 <chr>    
#> 1 pnr      Pseudonymiseret cpr-nummer            Pseudonymised social… character
#> 2 barnmak  Blev ydelse ydet til patientens barn? Was the service prov… integer  
#> 3 speciale Ydelsens honoreringskode              Billing code of the … character
#> 4 honuge   Aar og uge for ydelse                 Year and week of ser… character
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
#>   name     danish_description                    english_description   data_type
#>   <chr>    <chr>                                 <chr>                 <chr>    
#> 1 pnr      Pseudonymiseret cpr-nummer            Pseudonymised social… character
#> 2 barnmak  Blev ydelse ydet til patientens barn? Was the service prov… integer  
#> 3 speciale Ydelsens honoreringskode              Billing code of the … character
#> 4 honuge   Aar og uge for ydelse                 Year and week of ser… character
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
#>   <chr>        <chr>                        <chr>                      <list>   
#> 1 patient_cpr  Pseudonymiseret cpr-nummer   Pseudonymised social secu… <chr [1]>
#> 2 samplingdate Dato for proevetagning       Date of sampling           <chr [2]>
#> 3 analysiscode Analysens NPU-kode           NPU code of analysis       <chr [1]>
#> 4 value        Numerisk resultat af analyse Numerical result of analy… <chr [1]>
#> 
#> 
```
