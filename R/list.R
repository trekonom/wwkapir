#' List available data topics, indicators and regions
#'
#' Retrieves a list of topics, indicators and regions from the
#'    Wegweiser Kommune Open Data API.
#'
#' @param what a character. One of `"indicator"`, `"topic"` or `"region"`
#' @param max maximum number of results to return
#' @param ... additional parameters
#' @param verbose be verbose
#'
#' @return A data.frame.
#'
#' @name wwk-list
#'
#' @examples
#' \dontrun{
#' wwk_list_indicator()
#' # Set the maximum number of results
#' wwk_list_indicator(max = 5)
#' # Search for indicators
#' wwk_list_indicator(search = "Frauen")
#' # Exclude indicators by ID
#' wwk_list_indicator(exclude = c(255, 273))
#' }

#' @rdname wwk-list
#' @export
wwk_list <- function(what, max = 10, ..., verbose = FALSE) {
  what <- match.arg(what, c("indicator", "topic", "region"))
  params <- c(
    list(max = max),
    list(...)
  )
  if (verbose) {
    print(params)
  }

  req <- httr2::request(wwk_url())
  req <- req_url_path_append(req, "rest", what, "list")
  req <- req_headers(
    req,
    "accept" = "application/json",
    `content` = "application/json"
  )
  req <- req_url_query(req, !!!params, .multi = "explode")
  req <- req_method(req, "GET")

  if (verbose) {
    print(httr2::req_dry_run(req))
  }
  resp <- req_perform(req)

  resp <- httr2::req_perform(req)
  content <- httr2::resp_body_json(resp)

  content_cleaned <- purrr::map(content, function(x) {
    purrr::map(x, function(x) {
      if (is.list(x)) list(unlist(x)) else x
    })
  })

  purrr::map_dfr(content_cleaned, ~ tibble::tibble(!!!.x))
}

#' @rdname wwk-list
#' @export
wwk_list_indicator <- function(max = 10, ..., verbose = FALSE) {
  wwk_list("indicator", ...)
}

#' @rdname wwk-list
#' @export
wwk_list_topic <- function(max = 10, ..., verbose = FALSE) {
  wwk_list("topic", ...)
}

#' @rdname wwk-list
#' @export
wwk_list_region <- function(max = 10, ..., verbose = FALSE) {
  wwk_list("region", ...)
}
