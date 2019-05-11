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

### The price of 0.42 BTC in the past 30 days

Let's do the same report as above, but instead of reporting the most recent value of the asset, let's report on the daily values from the past 30 days.

<details>
  <summary>Click here for a potential solution ... with fixed USD/HUF exchange rate</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(scales)
library(ggplot2)

forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

## USD in HUF
response <- GET('https://api.exchangeratesapi.io/latest?base=USD')
exchange_rates <- content(response)
usdhuf <- exchange_rates$rates$HUF
log_info('The current USD price is {forint(usdhuf)}')

## Bitcoin price in USD
coin_prices <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(coin_prices)

balance <- coin_prices[, .(date = as.Date(close_time), btcusd = close)]
str(balance)

balance[, btchuf := btcusd * usdhuf]
balance[, btc := BITCOINS]
balance[, value := btc * btchuf]
str(balance)

## ########################################################
## Report

ggplot(balance, aes(date, value)) + 
  geom_line() +
  xlab('') +
  ylab('') + 
  scale_y_continuous(labels = forint) +
  theme_bw() +
  ggtitle('My crypto fortune',
          subtitle = paste(BITCOINS, 'BTC'))

```

</details>

<details>
  <summary>Click here for a potential solution ... with daily corrected USD/HUF exchange rate</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(scales)
library(ggplot2)

forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

## USD in HUF
?GET
response <- GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 40,
    end_at   = Sys.Date(),
    base     = 'USD',
    symbols  = 'HUF'
  ))
exchange_rates <- content(response)
str(exchange_rates)
exchange_rates <- exchange_rates$rates

library(data.table)
usdhufs <- data.table(
  date = as.Date(names(exchange_rates)),
  usdhuf = as.numeric(unlist(exchange_rates)))
str(usdhufs)

## Bitcoin price in USD
coin_prices <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(coin_prices)

balance <- coin_prices[, .(date = as.Date(close_time), btcusd = close)]
str(balance)
str(usdhufs)

## rolling join to look up the most recently available USD/HUF rate
## (published on business days) for each calendar day
setkey(balance, date)
setkey(usdhufs, date)
balance <- usdhufs[balance, roll = TRUE]
str(balance)

balance[, btchuf := btcusd * usdhuf]
balance[, btc := BITCOINS]
balance[, value := btc * btchuf]
str(balance)

## ########################################################
## Report

ggplot(balance, aes(date, value)) + 
  geom_line() +
  xlab('') +
  ylab('') + 
  scale_y_continuous(labels = forint) +
  theme_bw() +
  ggtitle('My crypto fortune',
          subtitle = paste(BITCOINS, 'BTC'))
```

</details>

### The price of 0.42 BTC and 1.2 ETH in the past 30 days

Let's do the same report as above, but now we not only have 0.42 Bitcoin, but 1.2 Ethereum as well.

<details>
  <summary>Click here for a potential solution ...</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(scales)
library(ggplot2)

forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}

## ########################################################
## CONSTANTS

BITCOINS  <- 0.42
ETHEREUMS <- 1.2

## ########################################################
## Loading data

## USD in HUF
response <- GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 40,
    end_at   = Sys.Date(),
    base     = 'USD',
    symbols  = 'HUF'
  ))
exchange_rates <- content(response)
str(exchange_rates)
exchange_rates <- exchange_rates$rates

library(data.table)
usdhufs <- data.table(
  date = as.Date(names(exchange_rates)),
  usdhuf = as.numeric(unlist(exchange_rates)))
str(usdhufs)

## Cryptocurrency prices in USD
btc_prices <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
eth_prices <- binance_klines('ETHUSDT', interval = '1d', limit = 30)
coin_prices <- rbind(btc_prices, eth_prices)
str(coin_prices)

## DRY (don't repeat yourself)
balance <- rbindlist(lapply(c('BTC', 'ETH'), function(s) {
  binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[, .(
    date = as.Date(close_time),
    usdt = close,
    symbol = s
  )]
}))
str(balance)

balance[, amount := switch(
  symbol,
  'BTC' = BITCOINS,
  'ETH' = ETHEREUMS,
  stop('Unsupported coin')),
  by = symbol]
str(balance)

## rolling join
setkey(balance, date)
setkey(usdhufs, date)
balance <- usdhufs[balance, roll = TRUE] ## DT[i, j, by = ...]

str(balance)

balance[, value := amount * usdt * usdhuf]
str(balance)

## ########################################################
## Report

ggplot(balance, aes(date, value, fill = symbol)) + 
  geom_col() +
  xlab('') +
  ylab('') + 
  scale_y_continuous(labels = forint) +
  theme_bw() +
  ggtitle(
    'My crypto fortune',
    subtitle = balance[date == max(date), paste(paste(amount, symbol), collapse = ' + ')])
```

</details>

### Move helpers to a new R package

1. Click File / New Project / New folder and create a new R package -- that will fill in your newly created folder with a package skeleton delivering the `hello` function in the `hello.R` file.

2. Get familiar with:

    * the `DESCRIPTION` file

        * semantic versioning: https://semver.org
        * open-source license, see eg http://r-pkgs.had.co.nz/description.html#license or https://rstats-pkgs.readthedocs.io/en/latest/licensing.html

    * the `R` subfolder
    * the `man` subfolder
    * the `NAMESPACE` file

3. Install the package (in the Build menu), load it and try `hello()`, then `?hello`
4. Create a git repo (if not done that already) and add/commit this package skeleton
5. Add a new function called `forint` in the `R` subfolder:

<details>
  <summary>`forint.R`</summary>

```r
forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}
```

</details>

6. Install the package, re-load it, and try running `forint` eg calling on `42` -- realize it's failing
7. After loading the `scales` package (that delivers the `dollar` function), it works, but that's not how we need to fix this (see below)
8. Look at the docs of `forint` -- realize it's missing, so let's learn about `roxygen2` and update the `forint.R` file:

<details>
  <summary>`forint.R`</summary>

```r
#' Formats Hungarian Forint
#' @param x number
#' @return string
#' @export
#' @importFrom scales dollar
#' @examples
#' forint(100000)
#' forint(10.3241245125125)
forint <- function(x) {
  dollar(x, prefix = '', suffix = ' HUF')
}
```

</details>

9. Run `roxygen2` on the package by enabling it in the "Build" menu's "Configure Build Tools", then "Document" it, and make sure to check what changes happened in the `man`, `NAMESPACE` (you might need to delete the original one) and `DESCRIPTION` files
10. Keep committing to the git repo
11. Add a new function that gets the most recent USD/HUF rate with some logging using the `logger` package

    <details>
      <summary><code>converter.R</code></summary>

    ```r
    #' Converting USD to HUF
    #' @param usd number
    #' @return number
    #' @export
    #' @importFrom httr GET content
    #' @importFrom logger log_debug log_trace
    #' @examples
    #' convert_usd_to_huf(1)
    #' forint(convert_usd_to_huf(1))
    #' @seealso forint
    convert_usd_to_huf <- function(usd) {
      response <- GET('https://api.exchangeratesapi.io/latest?base=USD')
      exchange_rates <- content(response)$rates
      log_trace('Found {length(exchange_rates)} exchange rates for USD')
      usdhuf <- exchange_rates$HUF
      log_debug('1 USD currently costs {usdhuf} Hungarian Forints')
      usd * usdhuf
    }
    ```

    </details>

12. Try suppressing debug log messages in this package by `log_threshold`'s `namespace`

### Take-home assignment

You can either work on an actual project outlined below, OR you can decide to skip that task and contribute to open-source R packages and/or projects for you final grade.

If you decide to work on a spec'ed out project:

1. Create an R package with an open-source license and push to a public GitHub repo
2. Add a function called `eurusd` that looks up the most recent USD/EUR exchange rate via an API call and returns the rate as a number
3. Add another function called `eurusds` that takes two arguments (`date_from` and `date_to`) and returns a `data.table` object on the daily rates from `date_from` to the `date_to` dates provided with 2 columns (date and exchange rate)
4. Add `convert_usd_to_eur` function that looks up the most recent USD/EUR exchange rate and compute the provided USD amount in EUR (as a number)
5. Add `eur` function to the package, similar to `scales::dollar`, that formats a number to a string using the Euro sign, rounding up to 2 digits and using the comma as the `big.mark` (every 3 decimals)
6. Write a function that reverses `eur`, eg call it `uneur`, so it takes a string (eg `"-€0.10"`) and transforms to a number (eg `-0.10` in this case). Make sure it works with the "big mark" as well (eg for `"$100,000"`)
7. Add a vignette to the package that demos the use of `eur` and `eurusds` by fetching the daily volume of Bitcoins sold for "USDT" on Binance and reports the overall value of this asset in EUR on a `ggplot` for the past 45 days
8. Use `pkgdown` to generate a website for your package and host it on GitHub using the `gh-pages` branch

If you decide to skip the above described project and would rather contribute to open-source projects:

* Look for GitHub repos with tickets tagged with "help wanted", eg at http://github-help-wanted.com/?languages=R&labels=help+wanted&page=1&sort=created&order=desc
* Feel free to contribute simple things first, eg fixing typos or improving documentation, adding examples etc
* Make sure to check if the project has any contribution guide or similar, also check the previous PRs to get familiar with the process and style

Submission: send link to your R package's GitHub repo or your open-source contributions (PRs) via Moodle until Jun 9, 2019

## References

* AWS Console: https://ceu.signin.aws.amazon.com/console
* Binance (cryptocurrency exchange) API: https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md (R implementation available at https://github.com/daroczig/binancer)
* Foreign exchange rates API, eg https://exchangeratesapi.io
* Free MySQL database: https://remotemysql.com
* "Writing R Extensions" docs: https://cran.r-project.org/doc/manuals/r-release/R-exts.html
* Hadley Wickham's "R packages" book: http://r-pkgs.had.co.nz
* `pkgdown` package: https://pkgdown.r-lib.org/index.html
