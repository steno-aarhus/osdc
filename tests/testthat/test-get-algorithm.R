test_that("or logic is converted to R logic", {
  get_algorithm_logic("hba1c") |>
    expect_equal("(analysiscode == 'NPU27300' & value >= 48) | (analysiscode == 'NPU03835' & value >= 6.5)")
})

test_that("single regex is converted to R logic", {
  get_algorithm_logic("gld") |>
    expect_equal("stringr::str_detect(atc, '^A10')")
})

test_that("and logic and regex with other condition are converted to R logic", {
  # i.e., the regex is within a parenthesis
  get_algorithm_logic("podiatrist_services") |>
    expect_equal("(stringr::str_detect(speciale, '^54')) & (barnmak != 0)")
})
