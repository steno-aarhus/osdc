# Define toy data for lpr_adm
lpr_adm <- tibble(
  pnr = rep(sprintf("%018d", 1:6), 2),  # Padded to 18 digits
  recnum = sprintf("%018d", 1:12),  # Record ID as padded 18-digit strings
  d_inddto = as.Date(c(
    "1986-12-31", "1994-01-01", "1992-05-15", "2005-03-20",
    "1997-06-25", "2010-09-12", "1989-07-19", "2015-06-01",
    "2000-11-23", "2003-09-14", "2012-11-09", "2020-03-05"
  )),
  c_spec = c(
    "08", "03", "08", "10", "90", "07", "08", "90",
    "03", "10", "07", "08"  # Various department specialty codes
  )
)

# Define toy data for lpr_diag
lpr_diag <- tibble(
  recnum = sprintf("%018d", 1:12),
  c_diag = c(
    "24903", "DE103", "DE115", "DE134", "DC456", "DN102",
    "24902", "DE113", "DE134", "DE125", "DE150", "DC457"
  ),  # ICD8 + ICD10
  c_diagtype = c(
    "A", "A", "A", "A", "B", "A",
    "B", "A", "A", "A", "B", "A"  # Diagnosis types
  )
)

# Define toy data for kontakter
kontakter <- tibble(
  cpr = rep(sprintf("%018d", 1:6), 2),  # Padded CPR numbers
  dw_ek_kontakt = sprintf("%018d", 1:12),
  dato_start = as.Date(c(
    "2019-12-31", "2021-01-01", "2023-05-15", "2020-03-20",
    "2020-06-25", "2021-09-12", "2022-02-10", "2020-05-25",
    "2019-11-11", "2021-07-20", "2019-10-12", "2023-01-05"
  )),
  hovedspeciale_ans = c(
    "Endokrinologi", "Hæmatologi", "Karkirurgi", "Gastroenterologi",
    "Kardiologi", "Gynækologi og obstetrik", "Endokrinologi", "Hæmatologi",
    "Karkirurgi", "Gastroenterologi", "Kardiologi", "Gynækologi og obstetrik"
  )  # Various departments
)

# Define toy data for diagnoser
diagnoser <- tibble(
  dw_ek_kontakt = sprintf("%018d", c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)),
  diagnosekode = c(
    "DE113", "DE103", "DD123", "DE125", "DC456", "DN102",
    "DE120", "DE134", "DE115", "DE145", "DE101", "DE120"
  ),  # Only ICD10
  diagnosetype = c(
    "A", "B", "B", "A", "B", "A",
    "A", "A", "B", "B", "A", "A"
  ),
  senere_afkraeftet = c(
    "Nej", "Ja", "Nej", "Nej", "Ja", "Nej",
    "Ja", "Nej", "Ja", "Nej", "Ja", "Nej"
  )
)

test_that("Error verifying structure of the output: Output should be a tibble, with 4 columns, and correct column names", {

  # Run the function on toy data
  output <- include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)

  # Test if the output is a tibble
  expect_s3_class(output, "tbl_df")

  # Test the number of columns in the output
  expect_equal(ncol(output), 4)

  # Test if the correct column names are present
  expect_named(output, c("pnr", "date", "any_t1d_primary_diagnosis", "majority_t1d_primary_diagnoses"))
})

test_that("Error verifying output data Types: 'pnr' should be a character, 'date' a Date, and the remaining two variables should be logicals", {

  # Run the function on toy data
  output <- include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)

  # Test the data type of each column
  expect_type(output$pnr, "character")
  expect_type(output$date, "double")
  expect_type(output$any_t1d_primary_diagnosis, "logical")
  expect_type(output$majority_t1d_primary_diagnoses, "logical")
})

test_that("Error verifying pnr-level output values: Inspect logic for defining and counting diabetes diagnoses", {

  # Run the function on toy data
  output <- include_diabetes_diagnoses(lpr_diag, lpr_adm, diagnoser, kontakter)

  # Check the values for specific 'pnr' and 'date' pairs

  output_pnr_1 <- output %>% filter(pnr == "000000000000000001")
  expect_equal(output_pnr_1$any_t1d_primary_diagnosis, c(TRUE, TRUE))
  expect_equal(output_pnr_1$majority_t1d_primary_diagnoses, c(FALSE, FALSE))

  output_pnr_2 <- output %>% filter(pnr == "000000000000000002")
  expect_equal(output_pnr_2$any_t1d_primary_diagnosis, c(TRUE, TRUE))
  expect_equal(output_pnr_2$majority_t1d_primary_diagnoses, c(TRUE, TRUE))

  output_pnr_3 <- output %>% filter(pnr == "000000000000000003")
  expect_equal(output_pnr_3$any_t1d_primary_diagnosis, c(FALSE, FALSE))
  expect_equal(output_pnr_3$majority_t1d_primary_diagnoses, c(FALSE, FALSE))
})

test_that("Error in filtering diabetes diagnoses: Function should return 0 rows when no diabetes diagnoses are present", {

  # Simulate a dataset with no diabetes diagnoses
  output_no_diabetes_diags <- include_diabetes_diagnoses(
    lpr_diag = lpr_diag |> filter(stringr::str_detect(c_diag, '^2[45]|^DE1[0-4]', negate = TRUE)),
    lpr_adm = lpr_adm,
    diagnoser = diagnoser |> filter(stringr::str_detect(diagnosekode, '^2[45]|^DE1[0-4]', negate = TRUE)),
    kontakter = kontakter
  )

  # Test if the function returns 0 rows when no diabetes diagnoses are present
  expect_equal(nrow(output_no_diabetes_diags), 0)
})

test_that("Error verifying output values: Ensure function handles NA correctly when present in the data (edge Case, should not appear in register data)", {

  # Modify data to introduce NA values in the diagnosis
  lpr_diag_with_na <- lpr_diag
  lpr_diag_with_na$c_diag[1] <- NA  # Set the first diagnosis to NA

  output_with_na <- include_diabetes_diagnoses(lpr_diag = lpr_diag_with_na,
                                               lpr_adm = lpr_adm, diagnoser = diagnoser, kontakter = kontakter)

  # Ensure the function handles NA values correctly
  output_with_na_pnr_1 <- output_with_na %>% filter(pnr == "000000000000000001")
  expect_equal(output_with_na_pnr_1$any_t1d_primary_diagnosis, c(FALSE, FALSE))
  expect_equal(output_with_na_pnr_1$majority_t1d_primary_diagnoses, c(FALSE, FALSE))
})

