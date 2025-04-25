#' Export data
#'
#' Exports the statistical data for the specified 'Friendly URL' in the desired
#'    format.
#'
#' @param indikator a character vector fiendly indicator URLs
#' @param region a character vector of fiendly region URLs
#' @param year a character. Years for which data should be retrieved.
#' @param charset encoding to be used. Defaults to `UTF-8`.
#' @param format format in which data shgould be returned. One of `csv` or `json`.
#' @param verbose be verbose
#'
#' @return A data.frame.
#'
#' @name wwk-export
#'
#' @examples
#' \dontrun{
#' # Search for indicators
#' wwk_export(
#'   indikator = "geburten",
#'   region = "koeln",
#'   year = "2024"
#' )
#' # Multiple indiciators, regions and years
#' wwk_export(
#'   indikator = c("geburten", "sterbefaelle")
#'   region = c("koeln", "muenchen"),
#'   year = "2000-2024"
#' )
#' }

#' @rdname wwk-export
#' @export
wwk_export <- function(indikator = NULL,
                       region = NULL,
                       year = NULL,
                       format = "csv",
                       charset = "UTF-8",
                       verbose = FALSE) {
  format <- check_export_format(format)

  indikator <- paste(indikator, collapse = "+")
  region <- paste(region, collapse = "+")
  year <- paste(year, collapse = "+")
  path_append <- paste(indikator, region, year, sep = "+")
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
    "rest", "export",
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
