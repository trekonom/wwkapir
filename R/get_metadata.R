
#' Get metadata for a specific indicator
#'
#' @param indicator_id The ID of the indicator.
#' @return A list of metadata.
#' @export
wwk_get_metadata <- function(indicator_id) {
  url <- paste0("https://www.wegweiser-kommune.de/api/v2/open-data/indicators/", indicator_id)
  req <- httr2::request(url)
  resp <- httr2::req_perform(req)
  content <- httr2::resp_body_json(resp)

  content$data
}
