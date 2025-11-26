# Data sources

This document describes the sources of data needed by the OSDC algorithm
and gives a brief overview of each of these sources and how they might
look like. In addition, the final section contains information on how to
gain access to these data.

The algorithm uses these Danish registers as input data sources:

| Register                                            | Abbreviation  | Years          |
|:----------------------------------------------------|:--------------|:---------------|
| CPR-registerets befolkningstabel                    | `bef`         | 1968 - present |
| Laegemiddelstatistikregisteret                      | `lmdb`        | 1995 - present |
| Landspatientregisterets administrationstabel (LPR2) | `lpr_adm`     | 1977 - 2018    |
| Landspatientregisterets diagnosetabel (LPR2)        | `lpr_diag`    | 1977 - 2018    |
| Landspatientregisterets kontakttabel (LPR3)         | `kontakter`   | 2019 - present |
| Landspatientregisterets diagnosetabel (LPR3)        | `diagnoser`   | 2019 - present |
| Sygesikringsregisteret                              | `sysi`        | 1990 - 2005    |
| Sygesikringsregisteret                              | `sssy`        | 2006 - present |
| Laboratoriedatabasens forskertabel                  | `lab_forsker` | 2011 - present |

Danish registers used in the OSDC algorithm.

In a future revision, the algorithm can also use the Danish Medical
Birth Register to extend the period of time of valid inclusions further
back in time compared to what is possible using obstetric codes from the
National Patient Register.

## Data required from registers

The following is a list of the variables required from specific
registers in order for the package to classify diabetes status:

| Register                                                        | Variable          |
|:----------------------------------------------------------------|:------------------|
| CPR-registerets befolkningstabel (`bef`)                        | pnr               |
| CPR-registerets befolkningstabel (`bef`)                        | koen              |
| CPR-registerets befolkningstabel (`bef`)                        | foed_dato         |
| Laegemiddelstatistikregisteret (`lmdb`)                         | pnr               |
| Laegemiddelstatistikregisteret (`lmdb`)                         | eksd              |
| Laegemiddelstatistikregisteret (`lmdb`)                         | atc               |
| Laegemiddelstatistikregisteret (`lmdb`)                         | volume            |
| Laegemiddelstatistikregisteret (`lmdb`)                         | apk               |
| Laegemiddelstatistikregisteret (`lmdb`)                         | indo              |
| Landspatientregisterets administrationstabel (LPR2) (`lpr_adm`) | pnr               |
| Landspatientregisterets administrationstabel (LPR2) (`lpr_adm`) | recnum            |
| Landspatientregisterets administrationstabel (LPR2) (`lpr_adm`) | d_inddto          |
| Landspatientregisterets administrationstabel (LPR2) (`lpr_adm`) | c_spec            |
| Landspatientregisterets diagnosetabel (LPR2) (`lpr_diag`)       | recnum            |
| Landspatientregisterets diagnosetabel (LPR2) (`lpr_diag`)       | c_diag            |
| Landspatientregisterets diagnosetabel (LPR2) (`lpr_diag`)       | c_diagtype        |
| Landspatientregisterets kontakttabel (LPR3) (`kontakter`)       | cpr               |
| Landspatientregisterets kontakttabel (LPR3) (`kontakter`)       | dw_ek_kontakt     |
| Landspatientregisterets kontakttabel (LPR3) (`kontakter`)       | dato_start        |
| Landspatientregisterets kontakttabel (LPR3) (`kontakter`)       | hovedspeciale_ans |
| Landspatientregisterets diagnosetabel (LPR3) (`diagnoser`)      | dw_ek_kontakt     |
| Landspatientregisterets diagnosetabel (LPR3) (`diagnoser`)      | diagnosekode      |
| Landspatientregisterets diagnosetabel (LPR3) (`diagnoser`)      | diagnosetype      |
| Landspatientregisterets diagnosetabel (LPR3) (`diagnoser`)      | senere_afkraeftet |
| Sygesikringsregisteret (`sysi`)                                 | pnr               |
| Sygesikringsregisteret (`sysi`)                                 | barnmak           |
| Sygesikringsregisteret (`sysi`)                                 | speciale          |
| Sygesikringsregisteret (`sysi`)                                 | honuge            |
| Sygesikringsregisteret (`sssy`)                                 | pnr               |
| Sygesikringsregisteret (`sssy`)                                 | barnmak           |
| Sygesikringsregisteret (`sssy`)                                 | speciale          |
| Sygesikringsregisteret (`sssy`)                                 | honuge            |
| Laboratoriedatabasens forskertabel (`lab_forsker`)              | patient_cpr       |
| Laboratoriedatabasens forskertabel (`lab_forsker`)              | samplingdate      |
| Laboratoriedatabasens forskertabel (`lab_forsker`)              | analysiscode      |
| Laboratoriedatabasens forskertabel (`lab_forsker`)              | value             |

## Expected data structure

This section describes how the data sources listed from the above table
are expected to look like when they are input into the OSDC algorithm.
This should mimic the structure of the raw data as it appears within the
virtual machines of Statistics Denmark. The package does not support
inputs in their raw `.sas7bdat` format, and these must be converted to
`.parquet` files first, which can then be loaded in as DuckDB objects.
The [`registers2parquet`
package](https://dp-next.github.io/registers2parquet/) provides
functions to conveniently handle this.

In this document, we present the variable names in lower case, but case
may vary between data sources (and even between years in the same data
source) in real data. However, the package should be robust to
inconsistent casing, as we internally convert all variable names to
lower case.

A small note about the National Patient Register: It contains several
tables and types of data. The algorithm uses only hospital diagnosis
data contained in four registers, which are pairs of two related
registers used before 2019 (LPR2) and from 2019 onward (LPR3). So the
LPR2 to LPR3 equivalents are `lpr_adm` to `kontakter` and `lpr_diag` to
`diagnoser`. Most variables have direct equivalents between LPR2 and
LPR3, but it should be noted that while `c_spec` is the LPR2 equivalent
of `hovedspeciale_ans` in LPR3, the specialty values in
`hovedspeciale_ans` are coded as strings of the literal specialty names
unlike the padded integer codes that `c_spec` contains (in our
experience).

On Statistics Denmark, these tables are provided as a mix of separate
files for each calendar year prior to 2019 (in LPR2 format) and a single
file containing all the data from 2019 onward (LPR3 format). The two
tables can be joined with either the `recnum` variable (LPR2 data) or
the `dw_ek_kontakt` variable (LPR3 data).

### `bef`: CPR-registerets befolkningstabel

| name      | english_description                  |
|:----------|:-------------------------------------|
| pnr       | Pseudonymised social security number |
| koen      | Gender/sex                           |
| foed_dato | Date of birth                        |

Variables and their descriptions within the `bef` register. If you want
to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `lmdb`: Laegemiddelstatistikregisteret

| name   | english_description                             |
|:-------|:------------------------------------------------|
| pnr    | Pseudonymised social security number            |
| eksd   | Date of purchase                                |
| atc    | Atc code (fully specified)                      |
| volume | Number of daily standard doses (ddd) in package |
| apk    | Number of packages purchased                    |
| indo   | Indication code                                 |

Variables and their descriptions within the `lmdb` register. If you want
to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `lpr_adm`: Landspatientregisterets administrationstabel (LPR2)

| name     | english_description                  |
|:---------|:-------------------------------------|
| pnr      | Pseudonymised social security number |
| recnum   | Record id number                     |
| d_inddto | Date of admission or initial contact |
| c_spec   | Specialty code of department         |

Variables and their descriptions within the `lpr_adm` register. If you
want to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `lpr_diag`: Landspatientregisterets diagnosetabel (LPR2)

| name       | english_description |
|:-----------|:--------------------|
| recnum     | Record id number    |
| c_diag     | Diagnosis code      |
| c_diagtype | Diagnosis type      |

Variables and their descriptions within the `lpr_diag` register. If you
want to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `kontakter`: Landspatientregisterets kontakttabel (LPR3)

| name              | english_description                  |
|:------------------|:-------------------------------------|
| cpr               | Pseudonymised social security number |
| dw_ek_kontakt     | Record id number                     |
| dato_start        | Date of admission or initial contact |
| hovedspeciale_ans | Specialty of department              |

Variables and their descriptions within the `kontakter` register. If you
want to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `diagnoser`: Landspatientregisterets diagnosetabel (LPR3)

| name              | english_description                |
|:------------------|:-----------------------------------|
| dw_ek_kontakt     | Record id number                   |
| diagnosekode      | Diagnosis code                     |
| diagnosetype      | Diagnosis type                     |
| senere_afkraeftet | Was the diagnosis retracted later? |

Variables and their descriptions within the `diagnoser` register. If you
want to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `sysi`: Sygesikringsregisteret

| name     | english_description                              |
|:---------|:-------------------------------------------------|
| pnr      | Pseudonymised social security number             |
| barnmak  | Was the service provided to the patient’s child? |
| speciale | Billing code of the service (fully specified)    |
| honuge   | Year and week of service                         |

Variables and their descriptions within the `sysi` register. If you want
to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `sssy`: Sygesikringsregisteret

| name     | english_description                              |
|:---------|:-------------------------------------------------|
| pnr      | Pseudonymised social security number             |
| barnmak  | Was the service provided to the patient’s child? |
| speciale | Billing code of the service (fully specified)    |
| honuge   | Year and week of service                         |

Variables and their descriptions within the `sssy` register. If you want
to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

### `lab_forsker`: Laboratoriedatabasens forskertabel

| name         | english_description                  |
|:-------------|:-------------------------------------|
| patient_cpr  | Pseudonymised social security number |
| samplingdate | Date of sampling                     |
| analysiscode | Npu code of analysis                 |
| value        | Numerical result of analysis         |

Variables and their descriptions within the `lab_forsker` register. If
you want to see what the data *should* look like, see
[`simulate_registers()`](https://steno-aarhus.github.io/osdc/reference/simulate_registers.md).

## Getting access to data

The above data is available through Statistics Denmark and the Danish
Health Data Authority. Researchers must be affiliated with an approved
research institute in Denmark and fees apply. Information on how to gain
access to data can be found at
`www.dst.dk/en/TilSalg/data-til-forskning` (URL often changes, so we
can’t link directly).
