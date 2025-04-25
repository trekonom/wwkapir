#' Suggest
#'
#' Get a list of suggested values to filter by demographic type,
#'    regional key, population range or region type.
#'
#' @param what a character. One of `"indicator"`, `"topic"` or `"region"`
#' @param max maximum number of results to return
#' @param exclude a character. Optional list of IDs of indicators, topics or
#'    regions to exclude.
#' @param search a character. Optional search text to look for indicators,
#'    topics or regions.
#' @param include_ars a boolean. Include 12-digit ARS in the search.
#' @param ... additional parameters
#' @param verbose be verbose
#'
#' @return A data.frame.
#'
#' @name wwk-suggest
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

#' @rdname wwk-suggest
#' @export
wwk_suggest <- function(what,
                        max = 10,
                        exclude = NULL,
                        search = NULL,
                        ...,
                        verbose = FALSE) {
  what <- match.arg(
    what,
    c("demographicType", "gkz", "populationRange", "regionType")
  )

  params <- c(
    list(
      max = max,
      exclude = exclude,
      search = search
    ),
    list(...)
  )
  if (verbose) {
    print(params)
  }

  req <- httr2::request(wwk_url())
  req <- req_url_path_append(req, "rest", "suggest", what)
  req <- req_headers(
    req,
    "accept" = "application/json",
    `content` = "application/json"
  )
  req <- req_url_query(req, !!!params, .multi = "explode")
  req <- req_method(req, "GET")

  if (verbose) {
    print(req_dry_run(req))
  }
  resp <- req_perform(req)

  content <- resp_body_json(resp)

  wwk_as_tibble_multi(content)
}

#' @rdname wwk-suggest
#' @export
wwk_suggest_demographic_type <- function(max = 10,
                                         exclude = NULL,
                                         search = NULL,
                                         verbose = FALSE) {
  wwk_suggest(
    "demographicType",
    max = max,
    exclude = exclude,
    search = search,
    verbose = verbose
  )
}

#' @rdname wwk-suggest
#' @export
wwk_suggest_gkz <- function(max = 10,
                            exclude = NULL,
                            search = NULL,
                            include_ars = TRUE,
                            verbose = FALSE) {
  wwk_suggest(
    "gkz",
    max = max,
    exclude = exclude,
    search = search,
    includeARS = include_ars,
    verbose = verbose
  )
}

#' @rdname wwk-suggest
#' @export
wwk_suggest_population_range <- function(max = 10,
                                         exclude = NULL,
                                         search = NULL,
                                         verbose = FALSE) {
  wwk_suggest(
    "populationRange",
    max = max,
    exclude = exclude,
    search = search,
    verbose = verbose
  )
}

#' @rdname wwk-suggest
#' @export
wwk_suggest_region_type <- function(max = 10,
                                    exclude = NULL,
                                    search = NULL,
                                    verbose = FALSE) {
  wwk_suggest(
    "regionType",
    max = max,
    exclude = exclude,
    search = search,
    verbose = verbose
  )
}
