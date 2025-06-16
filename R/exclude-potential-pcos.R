#' Exclude metformin purchases potentially for the treatment of polycystic ovary syndrome.
#'
#' Takes the output from [include_gld_purchases()] and `bef` (information on sex and date
#' of birth) to do the exclusions.
#' This function only performs a filtering operation so outputs the same structure and
#' variables as the input from [include_gld_purchases()], except the addition of a logical
#' helper variable `no_pcos` that is used in later functions.
#' After these exclusions are made, the output is used by `exclude_pregnancy()`.
#'
#' @param gld_purchases The output from [include_gld_purchases()].
#' @param bef The `bef` register.
#'
#' @return The same type as the input data, default as a [tibble::tibble()].
#'    It also has the same columns as [include_gld_purchases()], except for a logical
#'    helper variable `no_pcos` that is used in later functions.
#' @keywords internal
#' @inherit algorithm seealso
#'
#' @examples
#' \dontrun{
#' register_data <- simulate_registers(c("lmdb", "bef"), 100)
#' exclude_potential_pcos(
#'   gld_purchases = include_gld_purchases(register_data$lmdb),
#'   bef = register_data$bef
#' )
#' }
exclude_potential_pcos <- function(gld_purchases, bef) {
  criteria <- get_algorithm_logic("is_not_metformin_for_pcos") |>
    # To convert the string into an R expression
    rlang::parse_expr()

  # Use the algorithm criteria to exclude potential PCOS
  column_names_to_lower(gld_purchases) |>
    dplyr::inner_join(column_names_to_lower(bef), by = dplyr::join_by("pnr")) |>
    dplyr::mutate(
      date = lubridate::as_date(.data$date),
      foed_dato = lubridate::as_date(.data$foed_dato)
    ) |>
    # Use !! to inject the expression into filter
    dplyr::filter(!!criteria) |>
    # Keep only the columns we need
    dplyr::select(
      "pnr",
      "date",
      "atc",
      "contained_doses",
      "has_gld_purchases",
      "indication_code"
    ) |>
    # Add logical helper variable
    dplyr::mutate(no_pcos = TRUE)
}
