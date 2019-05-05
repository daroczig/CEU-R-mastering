This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/mastering-r-skills)" course in the 2018/2019 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU.

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

Please bring your own laptop and make sure to install R and RStudio  **before** attending the first class.

R packages to be installed:

* `data.table`
* `httr`
* `ggplot2`
* `scales`
* `zoo`
* `logger`
* `daroczig/binancer`
* `daroczig/logger`
* `daroczig/dbr`
* `RMySQL`
* `daroczig/botor` (requires Python and `boto3` Python module)
* `openxlsx`
* `devtools`

## Exercises solved from week to week

### The current price of 0.42 BTC

We have 0.42 Bitcoin. Let's write an R script reporting on the current value of this asset in USD.

<details>
  <summary>Spoiler ...</summary>
```r
library(devtools)
install_github('daroczig/binancer')

library(binancer)
coin_prices <- binance_ticker_all_prices()

library(data.table)
coin_prices[from == 'BTC' & to == 'USDT', to_usd]

## alternative solution
coin_prices <- binance_coins_prices()
coin_prices[symbol == 'BTC', usd]

## don't forget that we need to report on the price of 0.42 BTC instead of 1 BTC
coin_prices[symbol == 'BTC', usd * 0.42]
```
</details>
