#' Export Indicator Meta Data
#'
#' Exports the meta data for the specified indicators in the desired format.
#'
#' @param indicator a character vector of friendly indicator URLs.
#' @param charset encoding to be used. Defaults to `UTF-8`.
#' @param format format in which data shgould be returned. One of `csv` or `json`.
#' @param verbose be verbose
#'
#' @return a character (csv) or a list (json)
#'
#' @name wwk-export-indicator
#'
#' @examples
#' \dontrun{
#' # Search for one indicator
#' wwk_export_indicator(
#'   indicator = "geburten"
#' )
#' # Multiple indiciators
#' wwk_export_indicator(
#'   indicator = c("geburten", "sterbefaelle")
#' )
#' }

#' @rdname wwk-export-indicator
#' @export
wwk_export_indicator <- function(indicator = NULL,
                                 format = "csv",
                                 charset = "UTF-8",
                                 verbose = FALSE) {
  format <- check_export_format(format)

  indicator <- paste(indicator, collapse = "+")

  path_append <- paste(indicator, sep = "+")
  path_append <- paste0(
    path_append,
    "+tabelle.",
    format,
    "?charset=",
    charset
  )
  req <- httr2::request(wwk_url())
  req <- req_url_path_append(
    req,
    "rest", "indicator", "export",
    path_append
  )

  req <- req_headers(
    req,
    "accept" = "application/json"
  )
  req <- req_method(req, "GET")

  if (verbose) {
    print(httr2::req_dry_run(req))
  }
  resp <- req_perform(req)

  content_type <- httr2::resp_content_type(resp)

  if (content_type == "txt/csv") {
    content <- httr2::resp_body_string(resp)
  } else if (content_type == "application/json") {
    content <- httr2::resp_body_json(resp)
  }

  content
}
