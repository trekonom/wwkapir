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
