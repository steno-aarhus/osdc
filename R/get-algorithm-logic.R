#' Get the criteria algorithmic logic and convert to an R logic condition.
#'
#' @param criteria The name of the inclusion or exclusion criteria to use.
#'
#' @return A character string.
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' get_algorithm_logic("hba1c")
#' get_algorithm_logic("gld")
#' }
get_algorithm_logic <- function(criteria, algorithm_logic = algorithm) {
  algorithm_logic |>
    dplyr::filter(.data$name == criteria) |>
    dplyr::pull(.data$logic) |>
    stringr::str_replace_all("AND", "&") |>
    stringr::str_replace_all("OR", "|") |>
    # regex are defined with '=~', so convert them into a stringr function.
    stringr::str_replace_all("([a-zA-Z0-9_]+) \\=\\~ '(.*?)'", "stringr::str_detect(\\1, '\\2')")
}
