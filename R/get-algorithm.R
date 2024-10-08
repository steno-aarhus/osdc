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
#' }
get_algorithm_logic <- function(criteria) {
  algorithm |>
    dplyr::filter(.data$name == criteria) |>
    dplyr::pull(.data$logic) |>
    stringr::str_replace_all("AND", "&") |>
    stringr::str_replace_all("OR", "|")
}
