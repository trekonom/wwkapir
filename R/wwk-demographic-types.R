#' Demographic Types
#'
#' Retrieves a list of demographic types from the
#'    Wegweiser Kommune Open Data API.
#'
#' @param number a vector of length 1. Optional number of dempgraphic type for which
#'    meta data should be retrieved. Default to `NULL` in which case meta data
#'    on all demographic type is returned.
#' @param verbose be verbose
#'
#' @return a tibble
#'
#' @name wwk-demo-types
#'
#' @examples
#' \dontrun{
#' wwk_demographic_types()
#' }

#' @rdname wwk-demo-types
#' @export
wwk_demographic_types <- function(number = NULL, verbose = FALSE) {
  if (!is.null(number) && length(number) > 1) {
    stop("`number` should be length 1 vector.")
  }

  req <- httr2::request(wwk_url())
  req <- req_url_path_append(req, "rest", "demographicTypes", number)
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

  if (!is.null(number)) {
    wwk_as_tibble_single(content)
  } else {
    wwk_as_tibble_multi(content)
  }
}
