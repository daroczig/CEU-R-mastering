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

## Exercises

### The current price of 0.42 BTC

We have 0.42 Bitcoin. Let's write an R script reporting on the current value of this asset in USD.

<details>
  <summary>Click here for a potential solution ...</summary>

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

### The current price of 0.42 BTC in HUF

Let's do the same report as above, but instead of USD, now let's report in Hungarian Forints.

<details>
  <summary>Click here for a potential solution ...</summary>

```r
## How to get USD/HUF rate?
## See eg https://exchangeratesapi.io for free API access

## Loading data without any dependencies
readLines('https://api.exchangeratesapi.io/latest?base=USD')

## Parse JSON
library(jsonlite)
fromJSON(readLines('https://api.exchangeratesapi.io/latest?base=USD'))
fromJSON('https://api.exchangeratesapi.io/latest?base=USD')

## But we might better use a more flexible HTTP client ...
library(httr)
response <- GET('https://api.exchangeratesapi.io/latest?base=USD')
response
str(response)

headers(response)
content(response)
str(content(response))

content(response, as = 'text')
fromJSON(content(response, as = 'text'))

exchange_rates <- content(response)
str(exchange_rates)

## Extract the USD/HUF exchange rate from the list
usdhuf <- exchange_rates$rates$HUF
coin_prices[symbol == 'BTC', 0.42 * usd * usdhuf]
```

</details>

<details>
  <summary>Click here for a potential solution ... after cleaning up</summary>

```r
## loading requires packages on the top of the script
library(binancer)
library(httr)

## constants
BITCOINS <- 0.42

## get Bitcoin price in USD
coin_prices <- binance_coins_prices()
btcusdt <- coin_prices[symbol == 'BTC', usd]

## get USD/HUF exchange rate
exchange_rates <- content(response)
usdhuf <- exchange_rates$rates$HUF

## report
BITCOINS * btcusdt * usdhuf
```

</details>

<details>
  <summary>Click here for a potential solution ... with logging</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)

BITCOINS <- 0.42

coin_prices <- binance_coins_prices()
log_info('Found {coin_prices[, .N]} coins on Binance')
btcusdt <- coin_prices[symbol == 'BTC', usd]
log_info('The current Bitcoin price is ${btcusdt}')

response <- GET('https://api.exchangeratesapi.io/latest?base=USD')
exchange_rates <- content(response)$rates
log_info('Found {length(exchange_rates)} exchange rates for USD')
usdhuf <- exchange_rates$HUF
log_info('1 USD currently costs {usdhuf} Hungarian Forints')

log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdhuf * BITCOINS)} HUF')
```

</details>

<details>
  <summary>Click here for a potential solution ... with better currency formatter</summary>

```r
round(btcusdt * usdhuf * BITCOINS)
format(btcusdt * usdhuf * BITCOINS, big.mark = ',', digits = 10)
format(btcusdt * usdhuf * BITCOINS, big.mark = ',', digits = 6)

library(scales)
dollar(btcusdt * usdhuf * BITCOINS)
dollar(btcusdt * usdhuf * BITCOINS, prefix = '', suffix = ' HUF')

forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}
forint(btcusdt * usdhuf * BITCOINS)
```

</details>

<details>
  <summary>Click here for a potential solution ... with all of the above</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(scales)

forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

## Bitcoin price in USD
coin_prices <- binance_coins_prices()
log_info('Found {coin_prices[, .N]} coins on Binance')
btcusd <- coin_prices[symbol == 'BTC', usd]
log_info('The current BTC price is {btcusd} in USD')

## USD in HUF
response <- GET('https://api.exchangeratesapi.io/latest?base=USD')
exchange_rates <- content(response)
usdhuf <- exchange_rates$rates$HUF
log_info('The current USD price is {forint(usdhuf)}')

## ########################################################
## Report

forint(BITCOINS * btcusd * usdhuf)
```

</details>

