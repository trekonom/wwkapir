#' Read WWK CSV files
#'
#' Function to return WWK data retrieved in csv format as a tidy tibble.
#'
#' @details
#' The CSV files returned by the WWK API cannot be used directly for further analyses, as they contain:
#' 1. Lines with metadata at the beginning and end of the data set.
#'    * The first line contains the names of the indicators.
#'    * The second line contains the names of the regions.
#'    * Additional meta data is provided at the end.
#' 2. The data is returned in wide format:
#'    * Each row corresponds to an indicator.
#'    * The first column contains the name of the indicator.
#'    * All further columns contain the data for a region-year pair.
#'
#' @inheritParams readr::read_csv2
#'
#' @name wwk-read-csv
#'
#' @returns a tibble
#'
#' @examples
#' \dontrun{
#' csv <- wwk_export(
#'   indikator = c("geburten", "sterbefaelle"),
#'   region = c("koeln", "muenchen")
#' )
#' wwk_read_csv(csv)
#' }

#' @rdname wwk-read-csv
#' @export
wwk_read_csv <- function(file,
                         skip = 2,
                         n_max = Inf,
                         show_col_types = FALSE) {
  dat <- readr::read_csv2(
    file,
    skip = skip,
    n_max = n_max,
    show_col_types = show_col_types
  )
  dat <- remove_rows_not_na_col(dat)
  names(dat)[1] <- "indicator"
  tidyr::pivot_longer(
    dat,
    -"indicator",
    names_to = c("year", "region"),
    names_sep = "\n",
    names_transform = list(year = as.integer),
    values_transform = list(value = as.numeric)
  )
}

#' @rdname wwk-read-csv
#' @export
wwk_read_csv_indicator <- function(file,
                                   skip = 2,
                                   n_max = Inf,
                                   show_col_types = FALSE) {
  dat <- readr::read_csv2(
    file,
    skip = skip,
    n_max = n_max,
    show_col_types = show_col_types
  )
  dat <- remove_rows_not_na_col(dat)

  dat
}

# Copy & Paste from tblcleanr::remove_rows_not_na_col
remove_rows_not_na_col <- function(x, col = 1, rows = NULL, .direction = "up") {
  x[] <- lapply(x, as.character)
  if (is.character(rows)) {
    rows <- which(grepl(rows, x[, 1, drop = TRUE]))
    if (.direction == "down") {
      rows <- seq(max(rows), nrow(x), 1)
    } else {
      rows <- seq(max(rows))
    }
  }
  if (is.numeric(rows)) {
    is_row_drop <- seq(nrow(x)) %in% rows
  } else {
    is_row_drop <- rep(TRUE, nrow(x))
  }
  x <- cbind(is_row_drop, x)
  cols <- setdiff(seq_along(names(x)), c(1, col + 1))
  x <- x[!(is_row_drop & rowSums(is.na(x[cols])) == length(cols)), ,
    drop = FALSE
  ]
  x[["is_row_drop"]] <- NULL
  x
}
