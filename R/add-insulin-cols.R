#' Add columns for when two-thirds of doses are insulin and if only insulin was purchased.
#'
#' @param data A [tibble::tibble()] with at least the column `pnr`.
#' @param gld_purchases The output from [include_gld_purchases()].
#'
#' @returns A [tibble::tibble()] with two extra columns called
#'   `is_two_thirds_insulin` and `only_insulin_purchases`. These columns
#'    are logical variables indicating whether at least two-thirds of the
#'    GLD doses purchased are insulin doses and if only insulin was
#'    purchased.
#' @keywords internal
#' @inherit algorithm seealso
#'
add_two_thirds_and_only_insulin <- function(data, gld_purchases) {
  logic <- c(
    "is_two_thirds_insulin",
    "only_insulin_purchases"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)

  two_thirds_and_only_insulin <- gld_purchases |>
    dplyr::select(
      "pnr",
      "contained_doses",
      "is_insulin_gld_code",
      "is_non_insulin_gld_code"
    ) |>
    dplyr::summarise(
      insulin_doses = sum(
        .data$contained_doses[is_insulin_gld_code],
        na.rm = TRUE
      ),
      total_gld_doses = sum(.data$contained_doses, na.rm = TRUE),
      .by = "pnr"
    ) |>
    dplyr::mutate(
      # At least two-thirds of the doses are insulin doses:
      is_two_thirds_insulin = !!logic$is_two_thirds_insulin,
      # All doses are insulins:
      only_insulin_purchases = !!logic$only_insulin_purchases,
      .by = "pnr"
    ) |>
    dplyr::select(
      "pnr",
      "is_two_thirds_insulin",
      "only_insulin_purchases"
    )

  data |>
    dplyr::left_join(two_thirds_and_only_insulin, by = dplyr::join_by("pnr"))
}
