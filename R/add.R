#' Add columns for information about insulin drug purchases
#'
#' @param gld_purchases The data from [include_gld_purchases()] function.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'   Three new columns are added:
#'
#'   -   `has_two_thirds_insulin`: A logical variable used in classifying type 1
#'       diabetes. See [algorithm()] for more details.
#'   -   `has_only_insulin_purchases`: A logical variable used in classifying
#'       type 1 diabetes. See [algorithm()] for more details.
#'   -   `has_insulin_purchases_within_180_days`: A logical variable used in
#'       classifying type 1 diabetes. See [algorithm()] for more details.
#'
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' simulate_registers("lmdb", 10000)[[1]] |>
#'   include_gld_purchases() |>
#'   add_insulin_purchases_cols()
#' }
add_insulin_purchases_cols <- function(gld_hba1c_after_exclusions) {
  logic <- c(
    "is_insulin_gld_code",
    "has_two_thirds_insulin",
    "has_only_insulin_purchases",
    "has_insulin_purchases_within_180_days"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression.
    purrr::map(rlang::parse_expr)

  insulin_cols <- gld_hba1c_after_exclusions |>
    # `volume` is the doses contained in the purchased package and `apk` is the
    # number of packages purchased
    dplyr::mutate(
      contained_doses = .data$volume * .data$apk,
      is_insulin_gld_code = !!logic$is_insulin_gld_code,
      date = lubridate::ymd(date)
    ) |>
    dplyr::select(
      "pnr",
      "date",
      "contained_doses",
      "is_insulin_gld_code"
    ) |>
    dplyr::summarise(
      # Get first date of a GLD purchase and if a purchase of insulin occurs
      # within 180 days of the first purchase.
      first_gld_date = min(date, na.rm = TRUE),
      has_insulin_purchases_within_180_days = any(
        !!logic$has_insulin_purchases_within_180_days
      ),
      # Sum up total doses of insulin and of all GLD.
      n_insulin_doses = sum(
        .data$contained_doses[.data$is_insulin_gld_code],
        na.rm = TRUE
      ),
      n_gld_doses = sum(.data$contained_doses, na.rm = TRUE),
      .by = "pnr"
    ) |>
    dplyr::mutate(
      # When at least two-thirds of the doses are insulin doses.
      has_two_thirds_insulin = !!logic$has_two_thirds_insulin,
      # When all doses are insulin.
      has_only_insulin_purchases = !!logic$has_only_insulin_purchases,
      .by = "pnr"
    ) |>
    dplyr::select(
      "pnr",
      "has_two_thirds_insulin",
      "has_only_insulin_purchases",
      "has_insulin_purchases_within_180_days"
    )

  gld_hba1c_after_exclusions |>
    dplyr::left_join(insulin_cols, by = dplyr::join_by("pnr"))
}
