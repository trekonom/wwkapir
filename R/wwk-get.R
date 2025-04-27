#' Get Meta Data
#'
#' Retrieves meta data on single topics, indicators and regions from the
#'    Wegweiser Kommune Open Data API.
#'
#' @param what a character. One of `"indicator"`, `"topic"` or `"region"`
#' @param friendly_url,indicator,topic,region friendly url of indicator, topic or region
#' @param verbose be verbose
#'
#' @return a tibble
#'
#' @name wwk-get
#'
#' @examples
#' \dontrun{
#' # Get meta data on an indicator
#' wwk_list_indicator("geburten")
#' # Get meta data on a region
#' wwk_get_region("koeln")
#' # Get meta data on a topic
#' wwk_get_topic("anteil-der-altersgruppen")
#' }

#' @rdname wwk-get
#' @export
wwk_get <- function(what, friendly_url, verbose = FALSE) {
  what <- match.arg(what, c("indicator", "topic", "region"))

  req <- httr2::request(wwk_url())
  req <- req_url_path_append(req, "rest", what, "get", friendly_url)
  req <- req_headers(
    req,
    "accept" = "application/json",
    `content` = "application/json"
  )
  req <- req_method(req, "GET")

  if (verbose) {
    print(req_dry_run(req))
  }
  resp <- req_perform(req)

  content <- resp_body_json(resp)

  wwk_as_tibble_single(content)
}

#' @rdname wwk-get
#' @export
wwk_get_indicator <- function(indicator, verbose = FALSE) {
  wwk_get("indicator", friendly_url = indicator, verbose = verbose)
}

#' @rdname wwk-get
#' @export
wwk_get_topic <- function(topic, verbose = FALSE) {
  wwk_get("topic", friendly_url = topic, verbose = verbose)
}

#' @rdname wwk-get
#' @export
wwk_get_region <- function(region, verbose = FALSE) {
  wwk_get("region", friendly_url = region, verbose = verbose)
}
