## code to prepare `DATASET` dataset goes here
url <- "https://www.wegweiser-kommune.de/openapi?format=JSON"

download.file(url, "inst/openapi.json")
