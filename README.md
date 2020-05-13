This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/mastering-r-skills)" course in the 2019/2020 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU.

## Table of Contents

* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [API ingest and data transformation exercises](#api-ingest-and-data-transformation-exercises)
   * [Report on the current price of 0.42 BTC](#report-on-the-current-price-of-042-btc)
   * [Report on the current price of 0.42 BTC in HUF](#report-on-the-current-price-of-042-btc-in-huf)
   * [Move helpers to a new R package](#move-helpers-to-a-new-r-package)
   * [Report on the price of 0.42 BTC in the past 30 days](#report-on-the-price-of-042-btc-in-the-past-30-days)
   * [Report on the price of 0.42 BTC and 1.2 ETH in the past 30 days](#report-on-the-price-of-042-btc-and-12-eth-in-the-past-30-days)
   * [Report on the price of cryptocurrency assets read from a database](#report-on-the-price-of-cryptocurrency-assets-read-from-a-database)
   * [Report on the price of cryptocurrency assets based on the transaction history read from a database](#report-on-the-price-of-cryptocurrency-assets-based-on-the-transaction-history-read-from-a-database)
* [Homeworks](#homeworks)
   * [Week 1](#week-1)
   * [Week 2](#week-2)
* [References](#references)

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

0. Bookmark, watch or star this repository so that you can easily find it later
1. Please bring your own laptop and make sure to install R and RStudio **before** attending the first class!

    💪 R packages to be installed from CRAN via `install.packages`:

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
    * `roxygen2`
    * `pander`
    * `logger`
    * `botor` (requires Python and `boto3` Python module)

    💪 R packages to be installed from GitHub via `remotes::install_github`:

    * `daroczig/binancer`
    * `daroczig/logger`
    * `daroczig/dbr`

    If you get stuck, feel free to use the preconfigured, shared RStudio Server at http://mr.ceudata.net (I will share the usernames and passwords at the start of the class). In such case, you can skip all the steps prefixed with "💪" as the server already have that configured.

2. Join the #ba-mr-2019 Slack channel in the `ceu-bizanalytics` Slack group.
3. If you do not already have a GitHub account, create one
4. Create a new GitHub repository called `mastering-r`
5. 💪 Install `git` from https://git-scm.com/
6. 💪 Verify that in RStudio, you can see the path of the `git` executable binary in the Tools/Global Options menu's "Git/Svn" tab -- if not, then you might have to restart RStudio (if you installed git after starting RStudio) or installed git by not adding that to the PATH on Windows. Either way, browse the "git executable" manually (in some `bin` folder look for thee `git` executable file).
8. Create an RSA key via Tools/Global options/Git/Create RSA Key button (optionally with a passphrase for increased security -- that you have to enter every time you push and pull to and from GitHub), then copy the public key (from `~/.ssh/id_rsa.pub`) and add that to you SSH keys on your [GitHub profile](https://github.com/settings/ssh/new).
9. Create a new project in RStudio choosing "version control", then "git" and paste the SSH version of the repo URL copied from GitHub (from point 4) in the pop-up -- now RStudio should be able to download the repo. If it asks you to accept GitHub's fingerprint, say "Yes".
9. If RStudio/git is complaining that you have to set your identity, click on the "Git" tab in the top-right panel, then click on the Gear icon and then "Shell" -- here you can set your username and e-mail address in the command line, so that RStudio/git integration can work. Use the following commands:

    ```sh
    $ git config --global user.name "Your Name"
    $ git config --global user.email "Your e-mail address"
    ```
    Close this window, commit, push changes, all set.

Find more resources in Jenny Bryan's "[Happy Git and GitHub for the useR](http://happygitwithr.com/)" tutorial if in doubt or [contact me](#contact).

## API ingest and data transformation exercises

### Report on the current price of 0.42 BTC

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

### Report on the current price of 0.42 BTC in HUF

Let's do the same report as above, but instead of USD, now let's report in Hungarian Forints.

<details>
  <summary>Click here for a potential solution ...</summary>

```r
## How to get USD/HUF rate?
## See eg https://exchangeratesapi.io for free API access

## Loading data without any dependencies
https://api.exchangeratesapi.io/latest
https://api.exchangeratesapi.io/latest?base=USD

readLines('https://api.exchangeratesapi.io/latest?base=USD')

## Parse JSON
library(jsonlite)
fromJSON(readLines('https://api.exchangeratesapi.io/latest?base=USD'))
fromJSON('https://api.exchangeratesapi.io/latest?base=USD')

## Extract the USD/HUF exchange rate from the list
usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
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
usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF

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

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('1 USD currently costs {usdhuf} Hungarian Forints')

log_eval(forint(BITCOINS * btcusdt * usdhuf), level = INFO)
log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdhuf * BITCOINS)} HUF')
```

</details>

<details>
  <summary>Click here for a potential solution ... with validating values received from the API</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(checkmate)

BITCOINS <- 0.42

coin_prices <- binance_coins_prices()
log_info('Found {coin_prices[, .N]} coins on Binance')
btcusdt <- coin_prices[symbol == 'BTC', usd]
log_info('The current Bitcoin price is ${btcusdt}')
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('1 USD currently costs {usdhuf} Hungarian Forints')
assert_number(usdhuf, lower = 250, upper = 500)

log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdhuf * BITCOINS)} HUF')
```

</details>

<details>
  <summary>Click here for a potential solution ... with auto-retries for API errors</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(checkmate)

BITCOINS <- 0.42

get_bitcoin_price <- function() {
  tryCatch(
    binance_coins_prices()[symbol == 'BTC', usd],
    error = function(e) get_bitcoin_price())
}

btcusdt <- get_bitcoin_price()
log_info('The current Bitcoin price is ${btcusdt}')
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('1 USD currently costs {usdhuf} Hungarian Forints')
assert_number(usdhuf, lower = 250, upper = 500)

log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdhuf * BITCOINS)} HUF')
```

</details>

<details>
  <summary>Click here for a potential solution ... with auto-retries for API errors with exponential backoff</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(checkmate)

BITCOINS <- 0.42

get_bitcoin_price <- function(retried = 0) {
  tryCatch(
    binance_coins_prices()[symbol == 'BTC', usd],
    error = function(e) {
      ## exponential backoff retries
      Sys.sleep(1 + retried^2)
      get_bitcoin_price(retried = retried + 1)
    })
}

btcusdt <- get_bitcoin_price()
log_info('The current Bitcoin price is ${btcusdt}')
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('1 USD currently costs {usdhuf} Hungarian Forints')
assert_number(usdhuf, lower = 250, upper = 500)

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


### Move helpers to a new R package

1. Click File / New Project / New folder and create a new R package (maybe call it `mr`, also create a git repo for it) -- that will fill in your newly created folder with a package skeleton delivering the `hello` function in the `hello.R` file.

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
      <summary><code>forint.R</code></summary>

    ```r
    forint <- function(x) {
      dollar(x, prefix = '', suffix = ' HUF')
    }
    ```

    </details>

6. Install the package, re-load it, and try running `forint` eg calling on `42` -- realize it's failing
7. After loading the `scales` package (that delivers the `dollar` function), it works ... we need to prepare our package to load `scales::dollar` without user interventation
8. Also, look at the docs of `forint` -- realize it's missing, so let's learn about `roxygen2` and update the `forint.R` file to explicitely list the function to be exported and note that `dollar` is to be imported from the `scales` package:

    <details>
      <summary><code>forint.R</code></summary>

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

9. Run `roxygen2` on the package by enabling it in the "Build" menu's "Configure Build Tools", then "Document" it (if there's no such option, probably you need to install the `roxygen2` package first), and make sure to check what changes happened in the `man`, `NAMESPACE` (you might need to delete the original one) and `DESCRIPTION` files. It's also a good idea to automatically run `roxygen2` before each install, so I'd suggests marking that option as well. The resulting files should look something like:

    <details>
      <summary><code>DESCRIPTION</code></summary>

    ```
    Package: mr
    Type: Package
    Title: Demo R package for the Mastering R class
    Version: 0.1.0
    Author: Gergely <***@***.***>
    Maintainer: Gergely <***@***.***>
    Description: Demo R package for the Mastering R class
    License: AGPL
    Encoding: UTF-8
    LazyData: true
    RoxygenNote: 7.1.0
    Imports: scales
    ```

    </details>

    <details>
      <summary><code>NAMESPACE</code></summary>

    ```
    # Generated by roxygen2: do not edit by hand

    export(forint)
    importFrom(scales,dollar)
    ```

    </details>

10. Keep committing to the git repo
11. Delete `hello.R` and rerun `roxygen2` / reinstall the package
12. Add a new function that gets the most recent price of a Bitcoin in USD with retries:

    <details>
      <summary><code>converter.R</code></summary>

    ```r
    #' Hitting the Binance API to get the most recent price of a Bitcoin in USD
    #'
    #' This is a wrapper around the \code{binancer} package ...
    #' @export
    #' @param retried the number if retries previously done before the exponential backoff sleep
    #' @importFrom binancer binance_coins_prices
    get_bitcoin_price <- function(retried = 0) {
      tryCatch(
        ## not using data.table syntax here and falling back to data.frame
        ## so that this could run on systems wihtout data.table as well
        subset(binance_coins_prices(), symbol == 'BTC')$usd,
        error = function(e) {
          ## exponential backoff retries
          Sys.sleep(1 + retried^2)
          get_bitcoin_price(retried = retried + 1)
        })
    }
    ```

    </details>

13. Now you can run the original R script hitting the Binance and ExchangeRatesAPI by using these helper functions:

```r
library(binancer)
library(jsonlite)
library(logger)
library(checkmate)
library(scales)
log_threshold(TRACE)
library(mr)

BITCOINS <- 0.42
log_info('Number of Bitoins: {BITCOINS}')

btcusdt <- get_bitcoin_price()
log_info('The value of 1 Bitcoin: {dollar(btcusdt)}')
assert_number(btcusdt, lower = 1000)

usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The value of 1 USD: {forint(usdhuf)}')
assert_number(usdhuf, lower = 250, upper = 500)

log_eval(forint(BITCOINS * btcusdt * usdhuf))
```

### Report on the price of 0.42 BTC in the past 30 days

Let's do the same report as above, but instead of reporting the most recent value of the asset, let's report on the daily values from the past 30 days.

<details>
  <summary>Click here for a potential solution ... with fixed USD/HUF exchange rate</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(ggplot2)
library(mr)

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

## USD in HUF
usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF
log_info('The current USD price is {forint(usdhuf)}')

## Bitcoin price in USD
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(btcusdt)

balance <- btcusdt[, .(date = as.Date(close_time), btcusd = close)]
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
library(mr)

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

## USD in HUF
usdhuf <- fromJSON('https://api.exchangeratesapi.io/latest?base=USD&symbols=HUF')$rates$HUF

## try with a single date?
fromJSON('https://api.exchangeratesapi.io/2020-05-01?base=USD&symbols=HUF')
## no, it's just a single day
# fromJSON('https://api.exchangeratesapi.io/history?start_at=2020-05-01&base=USD&symbols=HUF')
## need end
fromJSON('https://api.exchangeratesapi.io/history?start_at=2020-05-01&end_at=2020-05-30&base=USD&symbols=HUF')
## we can do a much better job!

library(httr)
response <- GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 30,
    end_at   = Sys.Date(),
    base     = 'USD',
    symbols  = 'HUF'
  ))
exchange_rates <- content(response)
str(exchange_rates)
exchange_rates <- exchange_rates$rates

library(data.table)
usdhuf <- data.table(
  date = as.Date(names(exchange_rates)),
  usdhuf = as.numeric(unlist(exchange_rates)))
str(usdhuf)

## Bitcoin price in USD
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(btcusdt)

balance <- btcusdt[, .(date = as.Date(close_time), btcusd = close)]
str(balance)
str(usdhuf)

merge(balance, usdhuf, by = 'date')
## oh no, missing records??

## rolling join to look up the most recently available USD/HUF rate
## (published on business days) for each calendar day
setkey(balance, date)
setkey(usdhuf, date)
balance <- usdhuf[balance, roll = TRUE]
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

### Report on the price of 0.42 BTC and 1.2 ETH in the past 30 days

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
library(mr)

## ########################################################
## CONSTANTS

BITCOINS  <- 0.42
ETHEREUMS <- 1.2

## ########################################################
## Loading data

## USD in HUF
exchange_rates <- content(GET(
  'https://api.exchangeratesapi.io/history',
  query = list(
    start_at = Sys.Date() - 40,
    end_at   = Sys.Date(),
    base     = 'USD',
    symbols  = 'HUF'
  )))$rates

usdhuf <- data.table(
  date = as.Date(names(exchange_rates)),
  usdhuf = as.numeric(unlist(exchange_rates)))

## Cryptocurrency prices in USD
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
ethusdt <- binance_klines('ETHUSDT', interval = '1d', limit = 30)
coinusdt <- rbind(btcusdt, ethusdt)
str(coinusdt)
## oh no, how to keep the symbol??
balance <- coinusdt[, .(date = as.Date(close_time), btcusd = close, symbol = ???)]

## DRY (don't repeat yourself)
balance <- rbindlist(lapply(c('BTC', 'ETH'), function(s) {
  binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[, .(
    date = as.Date(close_time),
    usdt = close,
    symbol = s
  )]
}))

balance[, amount := switch(
  symbol,
  'BTC' = BITCOINS,
  'ETH' = ETHEREUMS,
  stop('Unsupported coin')),
  by = symbol]
str(balance)

## rolling join
setkey(balance, date)
setkey(usdhuf, date)
balance <- usdhuf[balance, roll = TRUE]

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


### Report on the price of cryptocurrency assets read from a database

1. Create a new MySQL account and database at some free service provider (eg remotemysql.com or freemysqlhosting.net)
2. Log in and give a try to PhpMyAdmin
3. 💪 Install `dbr` from GitHub:

    ```r
    library(devtools)
    install_github('daroczig/logger')
    install_github('daroczig/dbr')
    ```

4. Install `botor` as well to be able to use encrypted credentials (note that this requires you to install Python first and then `pip install boto3` as well):

    ```r
    install_github('daroczig/botor')
    ```

5. Set up a YAML file (menu: new file/text file, save as `databases.yml`) for the database connection, something like:

   ```shell
   remotemysql:
     host: remotemysql.com
     port: 3306
     dbname: ...
     user: ...
     drv: !expr RMySQL::MySQL()
     password: ...
   ```

6. Set up `dbr` to use that YAML file:

    ```r
    options('dbr.db_config_path' = '/path/to/databases.yml')
    ```

7. Create a table for the balances and insert some records:

    ```r
    library(dbr)
    db_config('remotemysql')
    db_query('CREATE TABLE coins (symbol VARCHAR(3) NOT NULL, amount DOUBLE NOT NULL DEFAULT 0)', 'remotemysql')
    db_query('TRUNCATE TABLE coins', 'remotemysql')
    db_query('INSERT INTO coins VALUES ("BTC", 0.42)', 'remotemysql')
    db_query('INSERT INTO coins VALUES ("ETH", 1.2)', 'remotemysql')
    ```

8. Write the reporting script, something like:

    <details>
      <summary>Click here for a potential solution ...</summary>

    ```r
    library(binancer)
    library(httr)
    library(data.table)
    library(logger)
    library(scales)
    library(ggplot2)
    library(mr)

    library(dbr)
    options('dbr.db_config_path' = '/path/to/databases.yml')
    options('dbr.output_format' = 'data.table')

    ## ########################################################
    ## Loading data

    ## Read actual balances from the DB
    balance <- db_query('SELECT * FROM coins', 'remotemysql')

    ## Look up cryptocurrency prices in USD and merge balances
    balance <- rbindlist(lapply(balance$symbol, function(s) {
      binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[, .(
        date = as.Date(close_time),
        usdt = close,
        symbol = s,
        amount = balance[symbol == s, amount]
      )]
    }))

    ## USD in HUF
    exchange_rates <- content(GET(
      'https://api.exchangeratesapi.io/history',
      query = list(
        start_at = Sys.Date() - 40,
        end_at   = Sys.Date(),
        base     = 'USD',
        symbols  = 'HUF'
      )))$rates
    usdhufs <- data.table(
      date = as.Date(names(exchange_rates)),
      usdhuf = as.numeric(unlist(exchange_rates)))

    ## rolling join USD/HUF exchange rate to balances
    setkey(balance, date)
    setkey(usdhufs, date)
    balance <- usdhufs[balance, roll = TRUE] ## DT[i, j, by = ...]

    ## compute daily values in HUF
    balance[, value := amount * usdt * usdhuf]

    ## ########################################################
    ## Report

    ggplot(balance, aes(date, value, fill = symbol)) +
      geom_col() +
      xlab('') +
      ylab('') +
      #scale_y_continuous(labels = forint) +
      theme_bw() +
      ggtitle(
        'My crypto fortune',
        subtitle = balance[date == max(date), paste(paste(amount, symbol), collapse = ' + ')])
    ```

    </details>

9. Rerun the above report after inserting two new records to the table:

    ```r
    db_query("INSERT INTO coins VALUES ('NEO', 100)", 'remotemysql')
    db_query("INSERT INTO coins VALUES ('LTC', 25)", 'remotemysql')
    ```

### Report on the price of cryptocurrency assets based on the transaction history read from a database

Let's prepare the transactions table:

```r
library(dbr)
options('dbr.db_config_path' = '/path/to/database.yml')
options('dbr.output_format' = 'data.table')

db_query('
  CREATE TABLE transactions (
    date TIMESTAMP NOT NULL,
    symbol VARCHAR(3) NOT NULL,
    amount DOUBLE NOT NULL DEFAULT 0)',
  db = 'remotemysql')

db_query('TRUNCATE TABLE transactions', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2020-01-01 10:42:02", "BTC", 1.42)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2020-01-01 10:45:20", "ETH", 1.2)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2020-02-28", "BTC", -1)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2020-04-13", "NEO", 100)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2020-04-20 12:12:21", "LTC", 25)', 'remotemysql')
```

<details>
  <summary>Click here for a potential solution for the report ...</summary>

```r
library(binancer)
library(httr)
library(data.table)
library(logger)
library(scales)
library(ggplot2)
library(zoo)
library(mr)

## ########################################################
## Loading data

## Read transactions from the DB
transactions <- db_query('SELECT * FROM transactions', 'remotemysql')

## Prepare daily balance sheets
balance <- transactions[, .(date = as.Date(date), amount = cumsum(amount)), by = symbol]
balance

## Transform long table into wide
balance <- dcast(balance, date ~ symbol)
balance

## Add missing dates
dates <- data.table(date = seq(from = Sys.Date() - 30, to = Sys.Date(), by = '1 day'))
balance <- merge(balance, dates, by = 'date', all.x = TRUE, all.y = TRUE)
balance

## Fill in missing values between actual balances
balance <- na.locf(balance)

## Fill in remaining missing values with zero
balance[is.na(balance)] <- 0

## Transform wide table back to long format
balance <- melt(balance, id.vars = 'date', variable.name = 'symbol', value.name = 'amount')
balance

## Get crypt prices
prices <- rbindlist(lapply(as.character(unique(balance$symbol)), function(s) {
    binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[
      , .(date = as.Date(close_time), symbol = s, usdt = close)]
}))
balance <- merge(balance, prices, by = c('date', 'symbol'), all.x = TRUE, all.y = FALSE)

## Merge USD/HUF rate
response <- GET(
    'https://api.exchangeratesapi.io/history',
    query = list(start_at = Sys.Date() - 30, end_at = Sys.Date(),
                 base = 'USD', symbols = 'HUF'))
exchange_rates <- content(response)$rates

usdhufs <- data.table(
    date = as.Date(names(exchange_rates)),
    usdhuf = as.numeric(unlist(exchange_rates)))

setkey(balance, date)
setkey(usdhufs, date)
balance <- usdhufs[balance, roll = TRUE]

## compute daily values in HUF
balance[, value := amount * usdt * usdhuf]

## ########################################################
## Report

ggplot(balance, aes(date, value, fill = symbol)) +
    geom_col() +
    ylab('') + scale_y_continuous(labels = forint) +
    xlab('') +
    theme_bw() +
    ggtitle(
        'My crypto fortune',
        subtitle = balance[date == max(date), paste(paste(amount, symbol), collapse = ' + ')])
```

</details>


## Homeworks

### Week 1

Create the `mr` R package described above with the `forint` and `get_bitcoin_price` functions, and push to a new repo in your GitHub account, so that you can install the package on any computer via `remotes::install_github`. Submit the URL to your GitHub repo in Moodle.

### Week 2

Add a new function to your `mr` package that queries historical exchange rates for any currency (so configurable `symbol` and `base` currency) for the past number of `days`. Example run:

```r
> convert_currency('EUR', 'USD', 2)
         date   rate
1: 2020-05-12 1.0858
2: 2020-05-13 1.0875
```

Don't forget about documenting the function!

## References

* AWS Console: https://ceu.signin.aws.amazon.com/console
* Binance (cryptocurrency exchange) API: https://github.com/binance-exchange/binance-official-api-docs/blob/master/rest-api.md (R implementation available at https://github.com/daroczig/binancer)
* Foreign exchange rates API, eg https://exchangeratesapi.io
* Free MySQL database: https://remotemysql.com
* "Writing R Extensions" docs: https://cran.r-project.org/doc/manuals/r-release/R-exts.html
* Hadley Wickham's "R packages" book: http://r-pkgs.had.co.nz
* Hadley Wickham's "Advanced R" book (1st edition): http://adv-r.had.co.nz/
* The `tidyverse` style guide: https://style.tidyverse.org/
* `pkgdown` package: https://pkgdown.r-lib.org/index.html
* `dbr` package: https://github.com/daroczig/dbr
