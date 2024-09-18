#' Include only those who have a purchase of a glucose lowering drug (GLD).
#'
#' See [algorithm] for the logic used to filter these patients.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#' @keywords internal
#'
#' @examples
#' \dontrun{
#' register_data$lmdb |> include_gld_purchases()
#' }
include_gld_purchases <- function(data) {
  verify_required_variables(data, "lmdb")
  criteria <- get_algorithm_logic("gld") |>
    # To convert the string into an R expression.
    rlang::parse_expr()
  data |>
    column_names_to_lower() |>
    # Use !! to inject the expression into filter.
    dplyr::filter(!!criteria) |>
    # Keep only the columns we need.
    dplyr::select(
      "pnr",
      # Change to date to work with later functions.
      date = "eksd",
      "atc",
      "volume",
      "apk",
      "indo",
      "name",
      "vnr"
    ) |>
    # TODO: Need to add this column? We did for hba1c.
    # dplyr::mutate(
    #   included_gld = TRUE
    # ) |>
    # Remove any duplicates
    dplyr::distinct()
}
