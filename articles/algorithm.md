# Algorithm

## General description

The current implementation of the algorithm is concisely described
below. A more complete description of the original implementation of the
classifier is found in Anders Aasted Isaksen’s [PhD
Thesis](https://aastedet.github.io/dissertation/) as well as the
validation paper.([1](#ref-Isaksen2023))

In brief, the algorithm first identifies a diabetes
population—regardless of diabetes type— based on four types of inclusion
events. It then classifies individuals within this population as having
type 1 diabetes (T1D) based on patterns in glucose-lowering drug
purchases and recorded type-specific diabetes diagnoses. Individuals who
do not meet the criteria for T1D are subsequently classified as having
type 2 diabetes (T2D).

Inclusion events are:

1.  HbA1c measurements of ≥48 mmol/mol.
2.  Hospital diagnoses of diabetes.
3.  Diabetes-specific services received at podiatrist.
4.  Purchase of glucose-lowering drugs.

Some inclusion events are ignored if any of the following exclusion
events apply:

1.  Elevated HbA1c samples are dropped if:
    - The sample was taken during pregnancies, as these may be related
      to gestational diabetes mellitus rather than T1D or T2D.
2.  Purchases of glucose-lowering drugs are dropped if:
    - The purchased drug is a GLP-1 receptor agonist, as this drug class
      is used extensively for weight loss among [individuals without
      diabetes](https://doi.org/10.2147/clep.s456170).
    - The purchased drug is dapagliflozin or empagliflozin, two types of
      SGLT-2 inhibitors recommended in Danish guidelines for treatment
      of [heart
      failure](https://www.cardio.dk/chf#551-farmakologisk-behandling-af-hfref)
      or [kidney
      failure](https://nephrology.dk/vejledninger/ckd-mbd/kronisk-nyresygdom/sglt2i_ckd_uden_dm/)
      among individuals without diabetes. This pertains only to
      purchases of drugs containing only this class of glucose-lowering
      drug. Purchases of combination drugs containing GLP-1 receptor
      agonists or SGLT-2 inhibitors in combination with other
      glucose-lowering drugs are not dropped.
    - The drug purchase is made during pregnancies, as these may be
      related to gestational diabetes mellitus, rather than T1D or T2D.
    - If the purchased drug is metformin and is made by women below age
      40, as these may be treatment for polycystic ovary syndrome
      (PCOS).
    - If the purchased drug is metformin with a PCOS-related indication
      code.

The diabetes classification date is defined at the date of the second
occurrence of any of the inclusion events listed above. For example, an
individual with two elevated HbA1c tests followed by a glucose-lowering
drug purchase is included at the latest elevated HbA1c test. Had the
second HbA1c test not been performed (or had it returned a result below
the diagnostic threshold), this person would instead have been included
at the date of the first purchase of glucose-lowering drugs. Wherever
possible, all available data for each event is used, except for the
purchases of glucose-lowering drugs, since the patient register data on
obstetric diagnoses necessary to censor glucose-lowering drug purchases
is only complete from 1997 onwards.

## High-level flowchart

``` mermaid
flowchart TD
  subgraph background_population["Background population"]
    lpr_diag[("lpr_diag")]
    lpr_adm[("lpr_adm")]
    kontakter[("kontakter")]
    diagnoser[("diagnoser")]
    sysi[("sysi")]
    sssy[("sssy")]
    lmdb[("lmdb")]
    lab_forsker[("lab_forsker")]
    bef[("bef")]
  end

    background_population --> diabetes_diagnoses["Include:<br>Hospital diagnoses of diabetes"]:::include
    background_population --> hba1c["Include:<br>HbA1c measurements of ≥48 mmol/mol"]:::include

    hba1c --> drop_pregnancies_hba1c["Exclude:<br>HbA1c measurements during pregnancies"]:::exclude

    background_population --> gld["Include:<br>Purchase(s) of glucose-lowering drugs used exclusively for treatment of diabetes"]:::include
    gld --> drop_pcos["Exclude:<br>Metformin purchases by women younger than 40 or with a PCOS-related indication code"]:::exclude
    drop_pcos --> drop_pregnancies_gld["Exclude:<br>GLD purchases during pregnancies"]:::exclude

    background_population --> podiatrist_services["Include:<br>Diabetes-specific podiatrist services"]:::include

    %% Join in classify
    drop_pregnancies_hba1c --> classify_t1d["Classification of type 1 diabetes"]
    drop_pregnancies_gld --> classify_t1d
    diabetes_diagnoses --> classify_t1d
    podiatrist_services --> classify_t1d

    classify_t1d --> classify_t2d["Not type 1 diabetes is classified as type 2 diabetes"]

    background_population ~~~ diabetes_diagnoses
    background_population ~~~ podiatrist_services
    background_population ~~~ hba1c

  %% Styling
  classDef default fill:#EEEEEE, color:#000000, stroke:#000000
  classDef include fill:lightblue
  classDef exclude fill:orange
  style background_population fill:#FFFFFF, color:#000000
```

Flow of inclusions and exclusions used for classifying diabetes status
using the osdc package. Light blue and orange boxes represent inclusions
and exclusions, respectively.

### Classifying type 1 diabetes

Diabetes type is classified as either T1D or T2D based on patterns of
purchases of insulin drugs (including analogues) and hospital primary
diagnoses of T1D and T2D.

For an individual to be classified as having T1D, the available data
needs to fulfill the criteria in either of the following branches of
logic:

1.  Must only have recorded purchases of insulin drugs and never any
    other type of glucose-lowering drugs, and have at least one primary
    diagnosis of T1D from a medical specialty hospital department.
2.  Must have a majority of T1D diagnoses from endocrinology departments
    (or from other medical specialty departments, in the absence of
    contacts to endocrinology departments), and a purchase of insulin
    within 180 days of their initial glucose-lowering drug purchase,
    with insulin contributing at least two thirds of all defined daily
    doses of glucose-lowering drugs purchased.

### Classifying type 2 diabetes

Individuals not classified as T1D cases are classified as T2D cases.

## Detailed and technical description

Below are the technical, exact implementation of the above description.
These are the logical conditions and exact variables and registers used
that results in the classification of diabetes status and types. They
are shown in the form of tables for each register with a table at the
end showing the logic that is applied across registers.

### `lpr_diag`

| name                      | title                                               | logic                                                                                                               | comments                                                                             |
|:--------------------------|:----------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------|
| lpr2_is_needed_code       | LPR2 codes used throughout the algorithm            | c_diag =~ ‘^(DO0\[0-6\]\|DO8\[0-4\]\|DZ3\[37\]\|DE1\[0-4\]\|249\|250)’ AND (c_diagtype == ‘A’ OR c_diagtype == ‘B’) | A `c_diagtype` of`'A'` means primary diagnosis, while ‘B’ means secondary diagnosis. |
| lpr2_is_diabetes_code     | LPR2 diagnoses codes for any diabetes               | c_diag =~ ‘^(DE1\[0-4\]\|249\|250)’                                                                                 |                                                                                      |
| lpr2_is_t1d_code          | LPR2 diagnoses codes for T1D                        | c_diag =~ ‘^(DE10\|249)’                                                                                            |                                                                                      |
| lpr2_is_t2d_code          | LPR2 diagnoses codes for T2D                        | c_diag =~ ‘^(DE11\|250)’                                                                                            |                                                                                      |
| lpr2_is_pregnancy_code    | LPR2 diagnoses codes for pregnancy-related outcomes | c_diag =~ ‘^(DO0\[0-6\]\|DO8\[0-4\]\|DZ3\[37\])’                                                                    | These are recorded pregnancy endings like live births and miscarriages.              |
| lpr2_is_primary_diagnosis | LPR2 primary diagnosis                              | c_diagtype == ‘A’                                                                                                   |                                                                                      |

### `lpr_adm`

| name                       | title                         | logic                    | comments                                                                                 |
|:---------------------------|:------------------------------|:-------------------------|:-----------------------------------------------------------------------------------------|
| lpr2_is_endocrinology_dept | LPR2 endocrinology department | c_spec == 8              | `TRUE` when the department where the recorded diagnosis was endocrinology.               |
| lpr2_is_medical_dept       | LPR2 other medical department | c_spec %in% c(1:7, 9:30) | `TRUE` when the diagnosis was recorded at a medical department other than endocrinology. |

### `diagnoser`

| name                      | title                                                 | logic                                                                                                                                                | comments                                                                                                |
|:--------------------------|:------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|
| lpr3_is_needed_code       | LPR3 codes used throughout the algorithm              | diagnosekode =~ ‘^(DO0\[0-6\]\|DO8\[0-4\]\|DZ3\[37\]\|DE1\[0-4\])’ AND (diagnosetype == ‘A’ OR diagnosetype == ‘B’) AND (senere_afkraeftet == ‘Nej’) | `A` `diagnosekode` means primary diagnosis and `senere_afkraeftet` means diagnosis was later retracted. |
| lpr3_is_primary_diagnosis | LPR3 primary diagnosis                                | diagnosetype == ‘A’                                                                                                                                  |                                                                                                         |
| lpr3_is_t1d_code          | LPR3 diagnoses codes for T1D                          | diagnosekode =~ ‘^(DE10)’                                                                                                                            |                                                                                                         |
| lpr3_is_t2d_code          | LPR3 diagnoses codes for T2D                          | diagnosekode =~ ‘^(DE11)’                                                                                                                            |                                                                                                         |
| lpr3_is_diabetes_code     | LPR3 diagnoses codes for diabetes                     | diagnosekode =~ ‘^DE1\[0-4\]’                                                                                                                        | This is a general diabetes code, not specific to T1D or T2D.                                            |
| lpr3_is_pregnancy_code    | ICD-10 diagnoses codes for pregnancy-related outcomes | diagnosekode =~ ‘^(DO0\[0-6\]\|DO8\[0-4\]\|DZ3\[37\])’                                                                                               | These are recorded pregnancy endings like live births and miscarriages.                                 |

### `kontakter`

| name                       | title                         | logic                                                                                                                                                                                                                                                                                                                                                                             | comments                                                                      |
|:---------------------------|:------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------|
| lpr3_is_endocrinology_dept | LPR3 endocrinology department | hovedspeciale_ans == ‘medicinsk endokrinologi’                                                                                                                                                                                                                                                                                                                                    | `TRUE` when the department is endocrinology.                                  |
| lpr3_is_medical_dept       | LPR3 medical department       | hovedspeciale_ans %in% c(‘blandet medicin og kirurgi’, ‘intern medicin’, ‘geriatri’, ‘hepatologi’, ‘hæmatologi’, ‘infektionsmedicin’, ‘kardiologi’, ‘medicinsk allergologi’, ‘medicinsk gastroenterologi’, ‘medicinsk lungesygdomme’, ‘nefrologi’, ‘reumatologi’, ‘palliativ medicin’, ‘akut medicin’, ‘dermato-venerologi’, ‘neurologi’, ‘onkologi’, ‘fysiurgi’, ‘tropemedicin’) | `TRUE` when the department is other medical departments (than endocrinology). |

### `lab_forsker`

| name                    | title                       | logic                                                                                           | comments                                                    |
|:------------------------|:----------------------------|:------------------------------------------------------------------------------------------------|:------------------------------------------------------------|
| is_hba1c_over_threshold | HbA1c values over threshold | (analysiscode == ‘NPU27300’ AND value \>= 48) OR (analysiscode == ‘NPU03835’ AND value \>= 6.5) | Is the IFCC units for NPU27300 and DCCT units for NPU03835. |

### `lmdb`

| name                | title                                       | logic                                                       | comments                                                                                                                            |
|:--------------------|:--------------------------------------------|:------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|
| is_gld_code         | ATC codes for glucose-lowering drugs (GLDs) | atc =~ ‘^A10’ AND NOT (atc =~ ‘^(A10BJ\|A10BK01\|A10BK03)’) | GLP-RAs or dapagliflozin/empagliflozin drugs are not kept.                                                                          |
| is_insulin_gld_code | Only insulin glucose-lowering drugs         | atc =~ ‘^A10A’ AND NOT (atc =~ ‘^A10AE56’)                  | This is used during the classification of type 1 diabetes to identify persons who only purchase insulin or mostly purchase insulin. |

### Across register logic

| name                                  | title                                                                          | logic                                                                                                                                                                                                                                                                                                  | comments                                                                                                                                                                                                                                                                                                      |
|:--------------------------------------|:-------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| is_within_pregnancy_interval          | Events that are within a potential pregnancy interval                          | has_pregnancy_event AND date \>= (pregnancy_event_date - weeks(40)) AND date \<= (pregnancy_event_date + weeks(12))                                                                                                                                                                                    | The potential pregnancy interval is defined as 40 weeks before and 12 weeks after the pregnancy event date (birth or miscarriage).                                                                                                                                                                            |
| is_podiatrist_services                | Podiatrist services                                                            | speciale =~ ‘^54’ AND barnmak == 0                                                                                                                                                                                                                                                                     | When `barnmak == 0`, the PNR belongs to the recipient of the service. When `barnmak == 1`, the PNR belongs to the child of the individual.                                                                                                                                                                    |
| is_not_metformin_for_pcos             | Metformin purchases that aren’t potentially for the treatment of PCOS          | NOT (koen == 2 AND atc =~ ‘^A10BA02\$’ AND ((date - foed_dato) \< years(40) OR indication_code %in% c(‘0000092’, ‘0000276’, ‘0000781’)))                                                                                                                                                               | Woman is defined as 2 in `koen`.                                                                                                                                                                                                                                                                              |
| has_t1d                               | Classifying type 1 diabetes status                                             | (from_diabetes_diagnosis OR from_podiatrist_service OR from_gld_purchase OR from_hba1c_over_threshold) AND (has_only_insulin_purchases & has_any_t1d_primary_diagnosis) OR (!has_only_insulin_purchases & has_majority_t1d_diagnoses & has_two_thirds_insulin & has_insulin_purchases_within_180_days) | The final classification for type 1 diabetes. Depends on all the previous steps to create these intermediate logical variables.                                                                                                                                                                               |
| has_any_t1d_primary_diagnosis         | Any primary diagnosis for type 1 diabetes                                      | (n_t1d_endocrinology + n_t1d_medical) \>= 1                                                                                                                                                                                                                                                            | This is used to classify type 1 diabetes. Naturally, having any type 1 diabetes diagnosis is indicative of type 1 diabetes.                                                                                                                                                                                   |
| has_majority_t1d_diagnoses            | Determine if the majority of diagnoses are for type 1 diabetes                 | if_else(n_t1d_endocrinology + n_t2d_endocrinology \> 0, n_t1d_endocrinology \> n_t2d_endocrinology, n_t1d_medical \> n_t2d_medical)                                                                                                                                                                    | This is used to classify type 1 diabetes. Endocrinology diagnoses are prioritised if available, otherwise other medical department diagnoses are used. If no diabetes type-specific primary diagnoses are available from an endocrinology or other medical departments, this variable is returned as `FALSE`. |
| has_two_thirds_insulin                | Whether two-thirds of GLD doses are insulin doses                              | (n_insulin_doses / n_gld_doses) \>= 2/3                                                                                                                                                                                                                                                                | This is used to classify type 1 diabetes. If multiple types of GLD are purchased, this indicates if at least two-thirds are insulin, which is important to determine type 1 diabetes status.                                                                                                                  |
| has_only_insulin_purchases            | Whether only insulin was purchased as a GLD                                    | n_insulin_doses \>= 1 & n_insulin_doses == n_gld_doses                                                                                                                                                                                                                                                 | This is used to classify type 1 diabetes. If only insulin is purchased, this is a strong reason to suspect type 1 diabetes.                                                                                                                                                                                   |
| has_insulin_purchases_within_180_days | Whether any insulin was purchased within 180 days of the first purchase of GLD | any(is_insulin_gld_code & date \<= (first_gld_date + days(180)))                                                                                                                                                                                                                                       | This is used to classify type 1 diabetes. It determines if any insulin was bought shortly after first buying any type of GLD, which suggests type 1 diabetes.                                                                                                                                                 |

## References

1\.

Isaksen AA, Sandbæk A, Bjerg L. [Validation of register-based diabetes
classifiers in danish data](https://doi.org/10.2147/clep.s407019).
Clinical Epidemiology. 2023 May;Volume 15:569–81.
