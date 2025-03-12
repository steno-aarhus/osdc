test_algorithm_logic <- data.frame(
  name = c("hba1c", "podiatrist_services", "gld", "some_gld"),
  logic = c(
    "(analysiscode == 'NPU27300' AND value >= 48) OR (analysiscode == 'NPU03835' AND value >= 6.5)",
    "(speciale =~ '^54') AND (barnmak != 0)",
    "atc =~ '^A10'",
    "atc =~ '^A10' AND !(atc =~ '^(A10BJ|A10D)')"
  )
)

test_that("`or` logic is converted to R logic", {
  get_algorithm_logic("hba1c", test_algorithm_logic) |>
    expect_equal("(analysiscode == 'NPU27300' & value >= 48) | (analysiscode == 'NPU03835' & value >= 6.5)")
})

test_that("single regex is converted to R logic", {
  get_algorithm_logic("gld", test_algorithm_logic) |>
    expect_equal("stringr::str_detect(atc, '^A10')")
})

test_that("`and` logic and regex within parentheses are converted to R logic", {
  # i.e., the regex is within a parenthesis
  get_algorithm_logic("podiatrist_services", test_algorithm_logic) |>
    expect_equal("(stringr::str_detect(speciale, '^54')) & (barnmak != 0)")
  get_algorithm_logic("some_gld", test_algorithm_logic) |>
    expect_equal("stringr::str_detect(atc, '^A10') & !(stringr::str_detect(atc, '^(A10BJ|A10D)'))")
})
