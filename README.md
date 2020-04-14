This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/mastering-r-skills)" course in the 2019/2020 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU.

## Table of Contents

* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [References](#references)

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

1. Please bring your own laptop and make sure to install R and RStudio **before** attending the first class.

    R packages to be installed from CRAN via `install.packages`:

    * `data.table`
    * `httr`
    * `jsonlite`
    * `lubridate`
    * `ggplot2`
    * `scales`
    * `zoo`
    * `RMySQL`
    * `RSQLite`
    * `openxlsx`
    * `googlesheets`
    * `devtools`
    * `pander`
    * `logger`
    * `botor` (requires Python and `boto3` Python module)

    R packages to be installed from GitHub via `remotes::install_github`:

    * `daroczig/binancer`
    * `daroczig/logger`
    * `daroczig/dbr`

    If you get stuck, feel free to use the preconfigured, shared RStudio Server at http://mr.ceudata.net (I will share the usernames and passwords at the start of the class).

2. Join the #ba-mr-2019 Slack channel in the `ceu-bizanalytics` Slack group.

## References

* AWS Console: https://ceu.signin.aws.amazon.com/console
* Binance (cryptocurrency exchange) API: https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md (R implementation available at https://github.com/daroczig/binancer)
* Foreign exchange rates API, eg https://exchangeratesapi.io
* Free MySQL database: https://remotemysql.com
* "Writing R Extensions" docs: https://cran.r-project.org/doc/manuals/r-release/R-exts.html
* Hadley Wickham's "R packages" book: http://r-pkgs.had.co.nz
* `pkgdown` package: https://pkgdown.r-lib.org/index.html
