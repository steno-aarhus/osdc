#' Add three columns indicating 1) if an insulin purchase has been made within 180 days of the first glucose-lowering drug purchase, 2) if two-thirds of purchased glucose-lowering drug doses are insulins, and 3) if insulin is the only glucose-lowering drug type ever purchased.
#'
#' @param data A [tibble::tibble()] with at least the column `pnr`.
#' @param gld_purchases The output from [include_gld_purchases()].
#'
#' @returns A [tibble::tibble()] with three new columns called
#'   `is_two_thirds_insulin` and `only_insulin_purchases`. `is_two_thirds_insulin`,  `only_insulin_purchases` and `insulin_purchases_within_180_days`. These columns are logical variables indicating 1) whether at least two-thirds of all purchased glucose-lowering drug doses are insulins, 2) if insulin is the only glucose-lowering drug type ever purchased, and 3) if an insulin purchase has been made within 180 days of the first glucose-lowering drug purchase.
#' @keywords internal
#' @inherit algorithm seealso
#'
add_insulin_classification_cols <- function(data, gld_purchases) {
  logic <- c(
    "is_two_thirds_insulin",
    "only_insulin_purchases",
    "insulin_purchases_within_180_days"
  ) |>
    rlang::set_names() |>
    purrr::map(get_algorithm_logic) |>
    # To convert the string into an R expression
    purrr::map(rlang::parse_expr)
  
  insulin_cols <- gld_purchases |>
    dplyr::mutate(date = lubridate::ymd(date)) |> 
    dplyr::select("pnr",
                  "date",
                  "contained_doses",
                  "is_insulin_gld_code",
                  "is_non_insulin_gld_code") |>
    # Calculate first date of a GLD purchase and if a purchase of insulin occurs within 180 day:
    dplyr::summarise(
      first_gld_date = min(date, na.rm = TRUE),
      insulin_purchases_within_180_days = !!logic$insulin_purchases_within_180_days,
      # Calculate total doses of insulin and of all GLD:
      insulin_doses = sum(.data$contained_doses[.data$is_insulin_gld_code], na.rm = TRUE),
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
      "only_insulin_purchases",
      "insulin_purchases_within_180_days"
    )
  
  data |>
    dplyr::left_join(insulin_cols, by = dplyr::join_by("pnr"))
    }
