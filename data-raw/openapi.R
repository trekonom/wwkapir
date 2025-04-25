## code to prepare `DATASET` dataset goes here

url <- "https://www.wegweiser-kommune.de/openapi?format=JSON"

download.file(url, "data-raw/openapi.json")

# https://petstore.swagger.io/?url=https://www.wegweiser-kommune.de/openapi#/default/get_rest_demographicTypes__number_
