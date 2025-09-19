test_algorithm_logic <- list(
  ands_ors = list(
    logic = "(analysiscode == 'NPU27300' AND value >= 48) OR (analysiscode == 'NPU03835' AND value >= 6.5)"
  ),
  regex_ands = list(
    logic = "(speciale =~ '^54') AND (barnmak != 0)"
  ),
  regex = list(
    logic = "atc =~ '^A10'"
  ),
  two_regex = list(
    logic = "atc =~ '^A10' AND !(atc =~ '^(A10BJ|A10D)')"
  )
)

test_that("algorithm outputs a list", {
  expect_type(algorithm(), "list")
  expect_type(algorithm()[[1]], "list")
})

test_that("`or` logic is converted to R logic", {
  get_algorithm_logic("ands_ors", test_algorithm_logic) |>
    expect_equal(
      "(analysiscode == 'NPU27300' & value >= 48) | (analysiscode == 'NPU03835' & value >= 6.5)"
    )
})

test_that("single regex is converted to R logic", {
  get_algorithm_logic("regex", test_algorithm_logic) |>
    expect_equal("stringr::str_detect(atc, '^A10')")
})

test_that("`and` logic and regex within parentheses are converted to R logic", {
  # i.e., the regex is within a parenthesis
  get_algorithm_logic("regex_ands", test_algorithm_logic) |>
    expect_equal("(stringr::str_detect(speciale, '^54')) & (barnmak != 0)")
  get_algorithm_logic("two_regex", test_algorithm_logic) |>
    expect_equal(
      "stringr::str_detect(atc, '^A10') & !(stringr::str_detect(atc, '^(A10BJ|A10D)'))"
    )
})

test_that("logic is converted to expression/call", {
  logic <- logic_as_expression("is_gld_code")
  expect_identical(class(logic), "list")
  expect_true(is.call(logic[[1]]))
})
