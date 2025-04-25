wwk_region_filter <- function(verbose = FALSE) {
  body <- list(
    #demographicTypes = list(0)
    gkzs = "05*"
  )
  body <- jsonlite::toJSON(body, auto_unbox = TRUE)

  req <- request(wwk_url()) |>
    req_url_path_append("rest/region/filter") |>
    req_headers("accept" = "application/json", 'Content-Type' = 'application/json') |>
    req_body_raw(body) |>
    req_method("POST")

  if (verbose) {
    req |>
      httr2::req_dry_run() |>
      print()
  }
  resp <- req_perform(req)

  content <- resp_body_json(resp, simplifyVector = TRUE)

  content
}
