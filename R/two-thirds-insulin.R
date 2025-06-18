#' Add column indicating if at least two-thirds of GLD doses are insulin doses.
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
    # To convert the string into an R expression
    rlang::parse_expr()

  two_thirds <- gld_purchases |>
    dplyr::select(
      "pnr",
      "date",
      "contained_doses",
      "is_insulin_gld_code",
      "is_non_insulin_gld_code"
    ) |>
    tidyr::pivot_longer(
      cols = c("is_insulin_gld_code", "is_non_insulin_gld_code")
    ) |>
    # Only want TRUE values of GLD codes.
    dplyr::filter(.data$value) |>
    dplyr::group_by(dplyr::pick(-c("contained_doses"))) |>
    dplyr::summarise(
      contained_doses = sum(.data$contained_doses, na.rm = TRUE),
      .groups = "keep"
    ) |>
    dplyr::ungroup() |>
    tidyr::pivot_wider(
      names_from = "name",
      values_from = "contained_doses"
    ) |>
    dplyr::rename(
      insulin_doses = "is_insulin_gld_code",
      non_insulin_doses = "is_non_insulin_gld_code"
    ) |>
    dplyr::mutate(
      gld_doses = .data$insulin_doses + .data$non_insulin_doses,
      # At least two-thirds of the doses are insulin doses.
      two_thirds_insulin_doses = !!logic
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "two_thirds_insulin_doses"
    )

  data |>
    dplyr::left_join(two_thirds, by = dplyr::join_by("pnr", "date"))
}
