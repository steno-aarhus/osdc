#' Include only those who have a purchase of a glucose lowering drug (GLD).
#'
#' See [algorithm] for the logic used to filter these patients.
#'
#' @param lmdb The LMDB register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data$lmdb |> include_gld_purchases()
#' }
include_gld_purchases <- function(lmdb) {
  verify_required_variables(lmdb, "lmdb")
  criteria <- get_algorithm_logic("gld") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  lmdb |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    dplyr::mutate(
      contained_doses = .data$volume * .data$apk,
      # An indicator variable for later joins
      has_gld_purchases = TRUE
    ) |>
    # Keep only the columns we need.
    dplyr::select(
      "pnr",
      # Change to date to work with later functions.
      date = "eksd",
      "atc",
      "contained_doses",
      "has_gld_purchases",
      indication_code = "indo"
    )
}
