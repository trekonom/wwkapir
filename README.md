
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 📦 rwwk

**rwwk** is an R package that provides functions to connect to and
retrieve data from the [Wegweiser Kommune Open Data REST
API](https://www.wegweiser-kommune.de/open-data). It simplifies
accessing municipal data for analysis, research, or reporting purposes.

------------------------------------------------------------------------

## 🔍 What is Wegweiser Kommune?

[Wegweiser Kommune](https://www.wegweiser-kommune.de/) is an initiative
by the Bertelsmann Stiftung offering open data and information to
support local authorities in Germany. It covers topics such as
demography, education, finances, health, and sustainability.

------------------------------------------------------------------------

## ✨ Features

- 📡 Simple functions to query the REST API
- 🔍 Search for available datasets, indicators, and metadata
- 🏙 Retrieve data for specific municipalities or time periods
- 📊 Return results as tidy `data.frame`s or tibbles
- 🔄 Built-in support for pagination and error handling

------------------------------------------------------------------------

## 🛠 Installation

``` r
# From GitHub (requires devtools or remotes)
remotes::install_github("trekonom/rwwk")
```

------------------------------------------------------------------------

## 🚀 Getting Started

``` r
library(rwwk)

# List available topics or indicators
topics <- ww_list_topics()
indicators <- ww_list_indicators()

# Retrieve data for an indicator
data <- wwk_get_data(indicator_id = "BEV001", region = "05315000", year = 2021)

# Explore the data
head(data)
```

------------------------------------------------------------------------

## 📚 Available Functions

| Function | Description |
|----|----|
| `wwk_list_topic()` | List available topic categories |
| `wwk_list_indicator()` | List all indicators with metadata |
| `wwk_list_regions()` | List all regions with metadata |
| `wwk_export()` | Retrieve data for specified indicators, regions, and years |

------------------------------------------------------------------------

## 🧪 Example Use Case

``` r
library(rwwk)
library(ggplot2)
library(tidyr)
library(readr)

# Get data on births and deaths for Cologne and Munich
csv <- wwk_export(
  indikator = c("geburten", "sterbefaelle"),
  region = c("koeln", "muenchen")
)

# skip = 2: Skip first 2 rows which contain meta data
# n_max = 2: Read only 2 rows which data on indicators to skip meta data at the tail
dat <- readr::read_csv2(csv, skip = 2, n_max = 2) |>
  tidyr::pivot_longer(
    -Indikatoren,
    names_to = c("year", "region"),
    names_sep = "\n",
    names_transform = list(year = as.integer)
  )
#> ℹ Using "','" as decimal and "'.'" as grouping mark. Use `read_delim()` for more control.
#> Rows: 2 Columns: 17
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ";"
#> chr  (1): Indikatoren
#> dbl (16): 2015
#> Köln, 2015
#> München, 2016
#> Köln, 2016
#> München, 2017
#> Köln, 2017
#> ...
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

years <- paste(range(dat$year), collapse = " bis ")
ggplot(dat, aes(x = year, y = value, color = region, group = region)) +
  geom_line() +
  facet_wrap(~Indikatoren) +
  labs(
    title = "Geburten und Sterbefälle",
    subtitle = sprintf("Köln und München, %s", years),
    x = NULL, y = NULL
  )
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

------------------------------------------------------------------------

## ⚙️ API Reference

This package wraps the REST API documented here:  
📖 <https://www.wegweiser-kommune.de/open-data>

You can optionally set an API key (if needed) using environment
variables or a config file. (Currently, the API appears to be
open-access without authentication.)
