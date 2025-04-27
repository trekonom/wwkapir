#' WWK API
#'
#' A convenience function to browse the API specs using `listviewer` (if installed).
#'
#' @returns invisible returns API specs as a list
#' @export
#'
#' @examples
#' wwk_api()
wwk_api <- function() {
  desc <- jsonlite::read_json(
    system.file("openapi.json", package = "wwkapir")
  )
  if (requireNamespace("listviewer")) {
    listviewer::jsonedit(desc)
  } else {
    desc
  }
}
