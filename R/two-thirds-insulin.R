#' Add column indicating if at least two-thirds of GLD doses are insulin doses
#'
#' @param data A [tibble::tibble()] with at least the columns `pnr` and `date`.
#' @param gld_purchases The output from [include_gld_purchases()].
#'
#' @returns A [tibble::tibble()] with one extra column called
#'   `two_thirds_insulin_doses`. This column is a logical variable indicating
#'   whether at least two-thirds of the GLD doses purchased are insulin doses.
#' @keywords internal
#' @inherit algorithm seealso
#'
add_two_thirds_insulin_doses <- function(data, gld_purchases) {
  logic <- get_algorithm_logic("is_two_thirds_insulin") |>
    # To convert the string into an R expression.
    rlang::parse_expr()

two_thirds_and_only_insulin <- gld_purchases  |>
  dplyr::select(
    "pnr",
    "contained_doses",
    "is_insulin_gld_code",
    "is_non_insulin_gld_code"
  ) |>
  dplyr::summarise(
    insulin_doses = sum(.data$contained_doses[is_insulin_gld_code], na.rm = TRUE),
    total_gld_doses = sum(.data$contained_doses, na.rm = TRUE),
    .groups = "keep",
    .by = "pnr"
  ) |>
  dplyr::mutate(
    # At least two-thirds of the doses are insulin doses:
    two_thirds_insulin_doses = !!logic,
    # All doses are insulins:
    only_insulin_purchases = .data$insulin_doses >= 1 & .data$insulin_doses == .data$total_gld_doses,
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
