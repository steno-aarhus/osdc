# Changelog

We use [Commitizen](https://commitizen-tools.github.io/commitizen/) to
automatically increase the versions, release the package on GitHub (with 
a tag), and auto-generate this NEWS file. The items listed below are
generated based on our commit messages that follow the
[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
standard.

## 0.9.6 (2025-11-19)

### Fix

- 🐛 convert NAs to FALSE at end in prep for classifying (#379)

## 0.9.5 (2025-11-19)

### Fix

- 🐛 changes to `drop_pregnancies()` to support the new refactored logic (#405)

## 0.9.4 (2025-11-19)

### Fix

- :bug: don't use `collect()` or `compute()` inside code, only outside (#403)
- :bug: convert NAs to FALSE and drop any if TRUE for pregnancy (#398)

## 0.9.3 (2025-11-19)

### Fix

- :bug: don't need to drop indication code after exclusion (#395)

### Refactor

- ♻️ add logical helper variables for inclusion events (#400)

## 0.9.2 (2025-11-17)

### Fix

- :bug: wrong value in the `c_diag` of the cases data (#394)

## 0.9.1 (2025-11-17)

### Refactor

- :recycle: enhance (non-)case data with sim data and convert to duckdb tibble (#396)

## 0.9.0 (2025-11-14)

### Feat

- :sparkles: require using DuckDB in `classify_diabetes()` (#391)

## 0.8.8 (2025-10-05)

### Fix

- :bug: logic around `is.na()` in pregnancy event isn't needed (#367)

## 0.8.7 (2025-10-03)

### Refactor

- :recycle: deselect columns we don't need later (#377)

## 0.8.6 (2025-10-03)

### Fix

- :bug: use `.data$` instead of quotes around `is_hba1c` (#376)

## 0.8.5 (2025-10-03)

### Fix

- :bug: remove HbA1c rows when calculating insulin columns (#371)

## 0.8.4 (2025-10-03)

### Refactor

- ♻️ add separate `keep_two_earliest_events()` function (#369)

## 0.8.3 (2025-10-02)

### Refactor

- :truck: rename `cases()` to `edge_cases()` to match file name (#368)

## 0.8.2 (2025-10-02)

### Fix

- :bug: use `full_join()` instead of `left_join()` (#365)

## 0.8.1 (2025-10-02)

### Fix

- :bug: remove rows with NA in both T1 and T2D (#363)

## 0.8.0 (2025-10-02)

### Feat

- :sparkles: add non-case of someone with PCOS (#362)

## 0.7.1 (2025-09-19)

### Refactor

- :truck: `drop_potential_pcos()` -> `drop_pcos()`  (#359)

## 0.7.0 (2025-09-19)

### Feat

- ✨ `create_inclusion_dates()` (#316)

### Refactor

- :truck: rename `inclusion_` and `exclusion_` to `keep_` and `drop_` (#356)

## 0.6.3 (2025-09-18)

### Refactor

- :recycle: convert logic parsing code into its own function (#350)

## 0.6.2 (2025-09-18)

### Refactor

- 🚚 rename to `exclude_pregnancies()` (#351)

## 0.6.1 (2025-09-18)

### Refactor

- :recycle: "parse, don't verify", select correct columns at start (#345)

## 0.6.0 (2025-09-18)

### Feat

- :sparkles: `classify_t1d()` (#309)

## 0.5.0 (2025-09-18)

### Feat

- ✨ `add_t1d_diagnoses_cols()` (#288)

## 0.4.2 (2025-09-18)

### Refactor

- :truck: rename to `keep_`, not `get_` for pregnancy dates (#346)

## 0.4.1 (2025-09-18)

### Refactor

- ♻️ move `add_insulin_purchases_cols()` down to after exclusions (#338)

## 0.4.0 (2025-09-16)

### Feat

- :sparkles: `add_insulin_purchases_cols()` (#296)

## 0.3.4 (2025-08-27)

### Refactor

- :truck: use `_diagnosis` for clearer language (#332)

## 0.3.3 (2025-08-25)

### Refactor

- :fire: `is_non_insulin_gld_code` isn't used, so removing it (#323)

## 0.3.2 (2025-08-25)

### Refactor

- :fire: remove most `has_` variables, they aren't needed anymore (#324)

## 0.3.1 (2025-08-25)

### Refactor

- :fire: no longer need `atc` after excluding pregnancy cases (#320)

## 0.3.0 (2025-08-22)

### Feat

- :sparkles: `check_data_types()` (#304)

## 0.2.0 (2025-08-22)

### Feat

- :sparkles: `join_inclusions()` added as step (#246)
- :sparkles: `include_diabetes_diagnoses()` (#258)
- ✨ `exclude_pregnancy()` (#261)
- :sparkles: first exclusion step (#243)
- :sparkles: add `exclude_potential_pcos()` (#214)
- :sparkles: add `simulate_registers()` (#208)
- :sparkles: skeleton of the core diabetes classification (#142)
- ✨  add `include_podiatrist_services()` with tests (#182)
- ✨ add simulated register data to `targets` pipeline (#167)
- ✨ update algorithm logic to include regex in parentheses (#159)
- :sparkles: add `include_gld_purchases()` (#138)
- add join_lpr3 with tests (#125)
- function to join the LPR2 registers (#118)
- add join_lpr3 with tests
- :sparkles: add the function to join the LPR2 registers
- create function to include HbA1c criteria
- add function that join inclusion events
- helper functions to insert data into Markdown vignettes
- internal function to extract logic from algorithm data. Untested
- create (draft) function to include HbA1c criteria
- added simulated data
- :construction: code to get list of Danish ICD 8 codes
- :construction: expand on the fixer functions for the simulation data
- add function to convert to lowercase.
- internal function to get the required variables for a register.
- function to get list of the registers abbreviations
- internal function to verify if the dataset has required variables.
- :sparkles: workflow that assigns PR author as assignee

### Fix

- :bug: update `algorithm()` examples with updated logic names (#302)
- :bug: refer to correct workflow in R-CMD-check badge (#299)
- **algorithm**: :bug: `barnmak` logic in `podiatrist_services` (#278)
- :bug: fixes notes about factors and reading CSV file (#248)
- :bug: rename pregnancy event variable in algorithm by removing `lpr2_` (#236)
- 🩹 don't filter to two first observations in `include_hba1c()` (#202)
- :bug: this function needs to be exported so Arrow can find it (#193)
- :bug: this function needs to be exported so Arrow can find it
- :memo: commit message auto-generated by `document` workflow (#183)
- :bug: regex works on more than one `=~` (#176)
- :bug: misc fixes to successfully run `r-cmd-check` (#168)
- 🐛 change honuge format to yyww (#165)
- :bug: verify function actually throws error (#128)
- the logic criteria wasn't being correctly loaded, need to convert to expression
- :art: remove duplicate arrow from function flow puml
- remove return since it's not needed
- add "indo" to condition since it's used in the function
- flip the condition so it's true when both "atc" and "name" is in data
- typos
- :bug: keep earliest two dates, not samples
- diagnosis -> diagnoses in inclusion function
- add missing header in output example table
- minor text edit to make sentence clearer
- specify that we use the primary diagnosis for classification
- update classify diabetes type flow chart based on feedback from @Aastedet
- describe classifying steps as "filters" with "criteria"
- add oxford comma to header
- :fire: remove old figure experiments
- we don't have tidyverse as a dependency, it isn't needed here
- add missing bracket
- apply suggestions from code review
- small fix to the comments and proportion of NPU units inserted
- :art: add space before register_abbrev
- NPU should be 8 long in total, not 8 integers
- add "_status" to the name of the "classify_diabetes" function
- minor text edits and change "classification date" to "inclusion date"
- typo
- remove all mentions of "before index date" since these filters are based on all data
- edits from code suggestions
- move set.seed up
- change pnr to only include 001-100 independent of `num_samples`
- removed leftover man/ file that triggers check warning
- DuckDB requires `colnames()`, not `names()`
- Minor text edits
- remove extra starting column
- convert the variable list into an exported object, not internal
- use the created function for getting the abbrev

### Refactor

- :recycle: add (non-)insulin drug indicator variables (#298)
- :recycle: rename `verify_required_variables()` to `check_required_variables()` (#306)
- ♻️ move column name lowercasing to `classify_diabetes()` (#295)
- :recycle: `criteria` -> `logic` (#294)
- :recycle: move lpr2 primary diagnosis logic to algorithm (#289)
- ♻️ update `join_lpr3()` to be `prepare_lpr3()` (#273)
- :recycle: make `yyww_to_yyyymmdd()` internal (#283)
- :recycle: update `prepare_lpr2()` col names to be `_dept` (#282)
- :recycle: align variable names in algorithm (#277)
- :recycle: update `join_lpr2()` to be `prepare_lpr2()` (#272)
- :recycle: remove verifying from internal functions (#259)
- :recycle: rename `cpr` column to `pnr` in `join_lpr3()` (#245)
- :recycle: moved registers into its own R code (#221)
- :recycle: change "!" to "NOT" (#226)
- :recycle: move algorithm into R file (#204)
- :recycle: add `contained_doses` variable to output (#187)
- :recycle: remove `name` and `vnr` (#185)
- :recycle: make joinable generated padded integers (#170)
- take a dataframe rather than a string name of the register
- these functions should only output data
- :recycle: convert the `data-raw/` scripts into functions
- kontakter should come first so `cpr` is first column, plus use inner join
- keep only earliest two dates, might not work with some databases
- move ICD8 processing into own section and store only relevant info
- completely refactor simulation code since simstudy was not working
- :recycle: rewrote and revised the code to add false metformin
- create function to make `pnr`, plus other small edits
