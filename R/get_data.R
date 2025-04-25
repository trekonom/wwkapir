
#' Get data for an indicator
#'
#' Fetches time-series data for a specific indicator and region.
#'
#' @param indicator_id The indicator to retrieve.
#' @param region The municipality ID (e.g., "05315000" for Köln).
#' @param year A numeric year or vector of years (optional).
#'
#' @return A data.frame with indicator values.
#' @export
wwk_get_data <- function(indicator_id, region, year = NULL) {
  base_url <- "https://www.wegweiser-kommune.de/api/v2/open-data/data"
  query_url <- paste0(base_url, "?indicator=", indicator_id, "&region=", region)

  req <- httr2::request(query_url)
  resp <- httr2::req_perform(req)
  content <- httr2::resp_body_json(resp)

  raw_data <- content$data
  df <- data.frame(
    year = sapply(raw_data, function(x) x$year),
    value = as.numeric(sapply(raw_data, function(x) x$value)),
    unit = sapply(raw_data, function(x) x$unit),
    stringsAsFactors = FALSE
  )

  if (!is.null(year)) {
    df <- df[df$year %in% year, ]
  }

  df
}
