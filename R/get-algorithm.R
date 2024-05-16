get_algorithm_logic <- function(criteria) {
  algorithm |>
    dplyr::filter(.data$name == criteria) |>
    dplyr::pull(.data$logic) |>
    stringr::str_replace_all("AND", "&") |>
    stringr::str_replace_all("OR", "|")
}
