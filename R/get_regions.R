
#' Get list of regions
#'
#' Returns a data.frame of available regions (municipalities) with their IDs.
#'
#' @return A data.frame of region IDs and names.
#' @export
wwk_get_regions <- function() {
  req <- httr2::request("https://www.wegweiser-kommune.de/api/v2/open-data/regions")
  resp <- httr2::req_perform(req)
  content <- httr2::resp_body_json(resp)

  data <- content$data
  data.frame(
    id = sapply(data, function(x) x$id),
    name = sapply(data, function(x) x$name),
    stringsAsFactors = FALSE
  )
}
