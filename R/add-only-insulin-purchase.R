#' Add column for persons who only purchase insulin drugs.
#'
#' This function adds a column to the input data indicating whether each person
#' has only purchased insulin drugs. It is used to classify type 1 diabetes
#' status.
#'
#' @param data A [tibble::tibble()] object with at least `pnr` data.
#' @param gld_purchases A [tibble::tibble()] object with GLD purchase
#'   information, with `is_insulin_gld_code` and `is_non_insulin_gld_code`
#'   columns, which should come from [include_gld_purchases()].
#'
#' @returns A [tibble::tibble()] object with one extra column
#'   `only_insulin_purchases`, that indicates whether a person has
#'   only purchased insulin drugs and no non-insulin drugs.
#' @keywords internal
#'
add_only_insulin_purchases <- function(data, gld_purchases) {
  only_insulin <- gld_purchases |>
    dplyr::select(
      "pnr",
      "is_insulin_gld_code",
      "is_non_insulin_gld_code"
    ) |>
    tidyr::pivot_longer(
      cols = c("is_insulin_gld_code", "is_non_insulin_gld_code")
    ) |>
    # Only want TRUE values of GLD codes.
    dplyr::filter(.data$value) |>
    dplyr::count("pnr", "name") |>
    tidyr::pivot_wider(
      names_from = "name",
      values_from = "n",
      values_fill = 0
    ) |>
    dplyr::filter(
      .data$is_insulin_gld_code >= 1 & .data$is_non_insulin_gld_code == 0
    ) |>
    dplyr::mutate(only_insulin_purchases = TRUE) |>
    dplyr::select("pnr", "only_insulin_purchases")

  data |>
    dplyr::left_join(only_insulin, by = dplyr::join_by("pnr"))
}
