#' Base URL
#' @noRd
wwk_url <- function() {
  "https://www.wegweiser-kommune.de/data-api"
}

#' Export Format
#'
#' Check for valid export format.
#'
#' @param x a character.
#'
#' @noRd
check_export_format <- function(x) {
  export_formats <- c("csv", "json")
  # c("csv", "gif", "jpg", "json", "pdf", "png", "svg", "xls", "xlsx")

  match.arg(
    x,
    export_formats
  )
}

#' Region Types
#'
#' Check for valid region types
#'
#' @param x a character.
#'
#' @noRd
check_region_types <- function(x) {
  region_types <- c(
    "BUND", "BUNDESLAND", "GEMEINDE",
    "KLEINE_GEMEINDE", "KREISFREIE_STADT", "LANDKREIS"
  )
  match.arg(x, region_types, several.ok = TRUE)
}

#' Tidy content
#'
#' Utility functions to retuern API content as a tibble
#'
#' @name wwk-as-tibble

#' @rdname wwk-as-tibble
#' @noRd
wwk_as_tibble_multi <- function(content) {
  content_cleaned <- purrr::map(content, function(x) {
    purrr::map(x, function(x) {
      if (is.list(x)) list(unlist(x)) else x
    })
  })

  purrr::map_dfr(content_cleaned, ~ tibble::tibble(!!!.x))
}

#' @rdname wwk-as-tibble
#' @noRd
wwk_as_tibble_single <- function(content) {
  content_cleaned <- purrr::map(content, function(x) {
    if (is.list(x)) list(unlist(x)) else x
  })

  tibble::tibble(!!!content_cleaned)
}
