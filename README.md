This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/2022-2023/mastering-r-skills)" course in the 2022/2023 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous edition, see [2018/2019 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2018-2019), [2019/2020 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2019-2020), and [2020/2021 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2020-2021).

## Table of Contents

* [Schedule](#schedule)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class materials](#class-materials)
  * [Report on the current price of 0.42 BTC](#report-on-the-current-price-of-042-btc)
  * [Report on the current price of 0.42 BTC in EUR](#report-on-the-current-price-of-042-btc-in-eur)
  * [Move helpers to a new R package](#move-helpers-to-a-new-r-package)
  * [Recap of week 1](#recap-of-week-1)
  * [Homework for week 1 gotchas](#homework-for-week-1-gotchas)
  * [Replace the home-brew retry with something better maintained](#replace-the-home-brew-retry-with-something-better-maintained)
  * [Speed up flaky API calls with caching](#speed-up-flaky-api-calls-with-caching)
  * [Report on the price of 0.42 BTC in the past 30 days](#report-on-the-price-of-042-btc-in-the-past-30-days)
  * [Make sure our helper functions work!](#make-sure-our-helper-functions-work)
  * [Recap of week 2](#recap-of-week-2)
  * [Homework for week 2 gotchas](#homework-for-week-2-gotchas)
  * [Report on the price of 0.42 BTC and 1.2 ETH in the past 30 days](#report-on-the-price-of-042-btc-and-12-eth-in-the-past-30-days)
  * [Report on the price of cryptocurrency assets read from a database](#report-on-the-price-of-cryptocurrency-assets-read-from-a-database)
  * [Report on the price of cryptocurrency assets based on the transaction history read from a database](#report-on-the-price-of-cryptocurrency-assets-based-on-the-transaction-history-read-from-a-database)
* [Home assignments](#homeworks)
  * [Week 1](#week-1)
  * [Week 2](#week-2)
  * [Week 3](#week-3)
* [References](#references)

## Schedule

2 x 150 mins on May 22, 31:

* 13:30 - 15:00 session 1
* 15:00 - 15:15 break
* 15:15 - 16:15 session 2

1 x 300 mins on June 5:

* 13:30 - 15:10 session 1
* 15:10 - 15:40 break
* 15:40 - 17:20 session 2
* 17:20 - 17:40 break
* 17:40 - 19:20 session 3

## Location

In-person at the Vienna campus (QS B-421).

## Syllabus

Please find in the `syllabus` folder of this repository.

## Technical Prerequisites

0. Bookmark, watch or star this repository so that you can easily find it later.
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
    * `googlesheets4`
    * `devtools`
    * `roxygen2`
    * `pander`
    * `logger`
    * `botor` (requires Python and the `boto3` Python module)
    * `purrr`
    * `memoise`

    💪 R packages to be installed from GitHub via `remotes::install_github`:

    * `daroczig/binancer`
    * `daroczig/logger`
    * `daroczig/dbr`

    If you get stuck, feel free to use the preconfigured, shared RStudio Server at http://mr.ceudata.net/rstudio (I will share the usernames and passwords at the start of the class). In such case, you can skip all the steps prefixed with "💪" as the server already have that configured.

2. Join the #ba-mr-2022 Slack channel in the `ceu-bizanalytics` Slack group.
3. If you do not already have a GitHub account, create one
4. Optionally create a new GitHub repository called `mastering-r` (or similar), but can be done later as well for th e R package (see below).
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

## Class materials

### Report on the current price of 0.42 BTC

We have 0.42 Bitcoin. Let's write an R script reporting on the current value of this asset in USD.

<details>
  <summary>Click here for a hint ...</summary>

  We installed the `binancer` package for a reason! Look up the related functions via `help(package = binancer)`.
</details>

<details>
  <summary>Click here for a potential solution ...</summary>

```r
## library(devtools)
## install_github('daroczig/binancer')

library(binancer)
coin_prices <- binance_coins_prices()
coin_prices[symbol == 'BTC', usd]

## don't forget that we need to report on the price of 0.42 BTC instead of 1 BTC
coin_prices[symbol == 'BTC', usd * 0.42]
```

</details>

### Report on the current price of 0.42 BTC in EUR

Let's do the same report as above, but instead of USD, now let's report in Euros.

<details>
  <summary>Click here for a potential solution ...</summary>

```r
## How to get EUR/HUF rate?
## See eg https://exchangerate.host for free API access

## Loading data without any dependencies
## https://api.exchangerate.host/latest
## https://api.exchangerate.host/latest?base=USD

readLines('https://api.exchangerate.host/latest?base=USD')

## Parse JSON
library(jsonlite)
fromJSON(readLines('https://api.exchangerate.host/latest?base=USD'))
fromJSON('https://api.exchangerate.host/latest?base=USD')

## Extract the USD/HUF exchange rate from the list
usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
coin_prices[symbol == 'BTC', 0.42 * usd * usdeur]
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
usdeur <- fromJSON('https://api.exchangerate.host/lat?base=USD&symbols=EUR')$rates$EUR

## report
BITCOINS * btcusdt * usdeur
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

usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
log_info('1 USD currently costs {usdeur} EUR')

log_eval(BITCOINS * btcusdt * usdeur, level = INFO)
log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdeur * BITCOINS)} EUR')
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

usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
log_info('1 USD currently costs {usdeur} EUR')
assert_number(usdeur, lower = 0.9, upper = 1.1)

log_info('{BITCOINS} Bitcoins now worth {round(btcusdt * usdeur * BITCOINS)} EUR')
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

get_usdeur <- function() {
  tryCatch({
    usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
    assert_number(usdeur, lower = 0.9, upper = 1.1)
  }, error = function(e) {
    ## str(e)
    log_error(e$message)
    Sys.sleep(1)
    get_usdeur()
  })
  log_info('1 USD={usdeur} EUR')
  usdeur
}

get_bitcoin_price <- function() {
  tryCatch({
      btcusdt <- binance_coins_prices()[symbol == 'BTC', usd]
      assert_number(btcusdt, lower = 1000)
      log_info('The current Bitcoin price is ${btcusdt}')
      btcusdt
  },
  error = function(e) {
    log_error(e$message)
    Sys.sleep(1)
    get_bitcoin_price()
  })
}

log_info('{BITCOINS} Bitcoins now worth {round(get_bitcoin_price() * get_usdeur() * BITCOINS)} EUR')
```

</details>

<details>
  <summary>Click here for a potential solution ... with auto-retries for API errors with exponential backoff</summary>

```r
get_usdeur <- function(retried = 0) {
  tryCatch({
    ## httr
    usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
    assert_number(usdeur, lower = 0.9, upper = 1.1)
  }, error = function(e) {
    ## str(e)
    log_error(e$message)
    if (retried > 3) {
      stop('Gave up')
    }
    Sys.sleep(1 + retried ^ 2)
    get_usdeur(retried = retried + 1)
  })
  log_info('1 USD={usdeur} EUR')
  usdeur
}
```

</details>

<details>
  <summary>Click here for a potential solution ... with better currency formatter</summary>

```r
round(btcusdt * usdeur * BITCOINS)
format(btcusdt * usdeur * BITCOINS, big.mark = ',', digits = 10)
format(btcusdt * usdeur * BITCOINS, big.mark = ',', digits = 6)

library(scales)
dollar(btcusdt * usdeur * BITCOINS)
dollar(btcusdt * usdeur * BITCOINS, prefix = '€')
dollar(btcusdt * usdeur * BITCOINS, prefix = '', suffix = ' EUR')

euro <- function(x) {
  dollar(x, prefix = '€')
}
euro(get_bitcoin_price() * get_usdeur() * BITCOINS)
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
5. Add a new function called `euro` in the `R` subfolder:

    <details>
      <summary><code>euro.R</code></summary>

    ```r
    euro <- function(x) {
      dollar(x, prefix = '€')
    }
    ```

    </details>

6. Install the package, re-load it, and try running `euro` eg calling on `42` -- realize it's failing
7. After loading the `scales` package (that delivers the `dollar` function), it works ... we need to prepare our package to load `scales::dollar` without user interventation
8. Also, look at the docs of `euro` -- realize it's missing, so let's learn about `roxygen2` and update the `euro.R` file to explicitely list the function to be exported and note that `dollar` is to be imported from the `scales` package:

    <details>
      <summary><code>euro.R</code></summary>

    ```r
    #' Formats number in EUR currency
    #' @param x number
    #' @return string
    #' @export
    #' @importFrom scales dollar
    #' @examples
    #' euro(1000)
    #' euro(10.3241245125125)
    euro <- function(x) {
      dollar(x, prefix = '€')
    }
    ```

    </details>

9. Run `roxygen2` on the package by enabling it in the "Build" menu's "Configure Build Tools", then "Document" it (if there's no such option, probably you need to install the `roxygen2` package first), and make sure to check what changes happened in the `man`, `NAMESPACE` (note that you might need to delete the original one) and `DESCRIPTION` files. It's also a good idea to automatically run `roxygen2` before each install, so I'd suggests marking that option as well. The resulting files should look something like:

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

    export(euro)
    importFrom(scales,dollar)
    ```

    </details>

10. Keep committing to the git repo
11. Delete `hello.R` and rerun `roxygen2` / reinstall the package
12. Add a new function that gets the most exchange rate for USD/EUR:

    <details>
      <summary><code>converter.R</code></summary>

    ```r
    #' Look up the value of a US Dollar in EURs
    #' @param retried number of times the function already failed
    #' @return number
    #' @export
    #' @importFrom jsonlite fromJSON
    #' @importFrom logger log_error log_info
    #' @importFrom checkmate assert_number
    get_usdeur <- function(retried = 0) {
      tryCatch({
        ## httr
        usdeur <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=EUR')$rates$EUR
        assert_number(usdeur, lower = 0.9, upper = 1.1)
      }, error = function(e) {
        ## str(e)
        log_error(e$message)
        if (retried > 3) {
          stop('Gave up')
        }
        Sys.sleep(1 + retried ^ 2)
        get_usdeur(retried = retried + 1)
      })
      log_info('1 USD={usdeur} EUR')
      usdeur
    }
    ```

    </details>

13. Now you can run the original R script hitting the Binance and exchangerate.host APIs by using these helper functions:

```r
library(binancer)
library(logger)
log_threshold(TRACE)
library(scales)
library(mr)

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

usdeur <- get_usdeur()

btcusd <- binance_coins_prices()[symbol == 'BTC', usd]
log_info('1 BTC={dollar(btcusd)}')

log_info('My crypto fortune is {euro(BITCOINS * btcusd * usdeur)}')
```

14. Make sure that the R package works as intended, and then push to Github.

### Recap of week 1

* writing helper functions
* API integrations
* documenting helper functions
* creating an R package from helper functions

### Homework for week 1 gotchas

* easy to mess up copy/paste
* make sure to test your function in a clean environment
* [import `data.table`](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-importing.html) if a package needs i!

The homework has been published at https://github.com/daroczig/CEU-R-mastering-demo-pkg/tree/76b283914380f05e0ddfdb44b98fe6560d86dc02

Let's fork the above repository and continue working on that from now on,
so that later we can also prepare a pull request for the main repo!

You can also install the above version of `mr` via:

```r
devtools::install_github('daroczig/CEU-R-mastering-demo-pkg')
```

### Replace the home-brew retry with something better maintained

Check out how `purrr::insistently` works!

1. Import the `insistently` function `purrr` with a roxygen tag
2. Add `purrr` to the `Imports` of your `DESCRIPTION` file
3. Drop the `tryCatch` handler and let the function fail on error
4. Wrap your function with `insistently`
5. Optionally enable reporting on errors via setting the `quiet` flag to `FALSE`

```r
#' Look up the current price of a Bitcoin in USD
#' @param retried number of times the function already failed
#' @return number
#' @export
#' @importFrom binancer binance_coins_prices
#' @importFrom logger log_error log_info
#' @importFrom checkmate assert_number
#' @import data.table
#' @importFrom purrr insistently
get_bitcoin_price <- insistently(function() {
    if (runif(1) > 0.5) stop('oh nooo') # TODO drop
    btcusdt <- binance_coins_prices()[symbol == 'BTC', usd]
    assert_number(btcusdt, lower = 1000)
    log_info('The current Bitcoin price is ${btcusdt}')
    btcusdt
}, quiet = FALSE)
```

### Speed up flaky API calls with caching

Check out how `memoise::memoise` works! Make sure to set a TTL (time to live) for the cached value .. crypto markets are changing rapidly :)

1. Import the `memoise` function `memoise` with a roxygen tag
2. Add `memoise` to the `Imports` of your `DESCRIPTION` file
3. Wrap your function with `memoise`
4. Look up the `cache_mem` function of the `cachem` package mentioned in the `memoise` docs
5. Set up a custom cache with a 5 seconds TTL by calling `cache_mem(max_age = 5)` as the `cache` argument of `memoise`, and make sure to do the related imports properly: add a roxygen tag to import `cache_mem` from `cachem` and add `cachem` in the `DESCRIPTION` file
6. Indent your code so that it is clear which argument belongs to which function

```r
#' Look up the current price of a Bitcoin in USD
#' @param retried number of times the function already failed
#' @return number
#' @export
#' @importFrom binancer binance_coins_prices
#' @importFrom logger log_error log_info
#' @importFrom checkmate assert_number
#' @import data.table
#' @importFrom purrr insistently
#' @importFrom memoise memoise
#' @importFrom cachem cache_mem
get_bitcoin_price <- memoise(
    insistently(
        function() {
            btcusdt <- binance_coins_prices()[symbol == 'BTC', usd]
            assert_number(btcusdt, lower = 1000)
            log_info('The current Bitcoin price is ${btcusdt}')
            btcusdt
        },
        quiet = FALSE),
    cache = cache_mem(max_age = 5)
)
```

### Report on the price of 0.42 BTC in the past 30 days

Let's do the same report as above, but instead of reporting the most recent value of the asset, let's report on the daily values from the past 30 days, e.g. on a line plot.

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

usdeur <- get_usdeur()

btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(btcusdt)

balance <- btcusdt[, .(date = as.Date(close_time), btcusd = close)]
str(balance)

balance[, btceur := btcusd * usdeur]
balance[, btc := BITCOINS]
balance[, value := btc * btceur]
str(balance)

## ########################################################
## Report

ggplot(balance, aes(date, value)) +
  geom_line() +
  xlab('') +
  ylab('') +
  scale_y_continuous(labels = euro) +
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

usdeur <- get_usdeur()

## try with a single date?
fromJSON('https://api.exchangerate.host/2023-05-01?base=USD&symbols=HUF')
## no, it's just a single day
# fromJSON('https://api.exchangerate.host/timeseries?start_date=2023-05-01&base=USD&symbols=HUF')
## need end
fromJSON('https://api.exchangerate.host/timeseries?start_date=2023-05-01&end_date=2023-05-05&base=USD&symbols=HUF')
## we can do a much better job!

library(httr)
response <- GET(
  'https://api.exchangerate.host/timeseries',
  query = list(
    start_date = Sys.Date() - 30,
    end_date   = Sys.Date(),
    base       = 'USD',
    symbols    = 'EUR'
  ))
exchange_rates <- content(response)
str(exchange_rates)
exchange_rates <- exchange_rates$rates

library(data.table)
usdeur <- data.table(
  date = as.Date(names(exchange_rates)),
  usdeur = as.numeric(unlist(exchange_rates)))
str(usdeur)
## NOTE last element might be an empty list if early in the day ...
##      query yesterday or drop last row when this occurs

## Bitcoin price in USD
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
str(btcusdt)

balance <- btcusdt[, .(date = as.Date(close_time), btcusd = close)]
str(balance)
str(usdeur)

balance <- merge(balance, usdeur, by = 'date')
balance[, btceur := btcusd * usdeur]
balance[, btc := 0.42]
balance[, value := btc * btceur]

## ########################################################
## Report

ggplot(balance, aes(date, value)) +
  geom_line() +
  xlab('') +
  ylab('') +
  scale_y_continuous(labels = euro) +
  theme_bw() +
  ggtitle('My crypto fortune',
          subtitle = paste(BITCOINS, 'BTC'))
```

</details>

Now let's create the `get_usdeurs` function (similar to `get_usdeur`) to take start and end dates! Although we can set the start and end date default to today, so would return the same value as `get_usdeur` and could be the latter deprecated, not that this new function will return a `data.frame` or `data.table` object, so thus there's value in keeping the previous one as well.

<details>
  <summary><code>exchange_rates.R</code></summary>

```r
#' Look up the value of a US Dollar in Euro
#' @param start_date date
#' @param end_date date
#' @return \code{data.table} object with dates and values
#' @export
#' @importFrom httr GET content
#' @importFrom logger log_error log_info
#' @importFrom checkmate assert_numeric
#' @importFrom data.table data.table
#' @importFrom purrr insistently
#' @importFrom memoise memoise
get_usdeurs <- memoise(
    insistently(
        function(start_date = Sys.Date(), end_date = Sys.Date()) {
            response <- GET(
                'https://api.exchangerate.host/timeseries',
                query = list(
                    start_date = start_date,
                    end_date   = end_date,
                    base       = 'USD',
                    symbols    = 'EUR'
                )
            )
            exchange_rates <- content(response)$rates
            usdeur <- data.table(
                date = as.Date(names(exchange_rates)),
                usdeur = as.numeric(unlist(exchange_rates)))
            assert_numeric(usdeur$usdeur, lower = 0.9, upper = 1.1)
            usdeur
        }
    )
)
```
</details>

<details>
  <summary><code>Cleaned up R script using the above helper function</code></summary>

```r
library(binancer)
library(data.table)
library(ggplot2)
library(mr)

## ########################################################
## CONSTANTS

BITCOINS <- 0.42

## ########################################################
## Loading data

usdeurs <- get_usdeurs(Sys.Date() - 30, Sys.Date())
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
balance <- btcusdt[, .(date = as.Date(close_time), btcusd = close)]

balance <- merge(balance, usdeurs, by = 'date')
balance[, btceur := btcusd * usdeur]
balance[, btc := BITCOINS]
balance[, value := btc * btceur]

## ########################################################
## Report

ggplot(balance, aes(date, value)) +
  geom_line() +
  xlab('') +
  ylab('') +
  scale_y_continuous(labels = euro) +
  theme_bw() +
  ggtitle('My crypto fortune',
          subtitle = paste(BITCOINS, 'BTC'))
```

</details>

### Make sure our helper functions work!

Make sure to consult the related chapter of Hadley Wickham's "R packages" book at http://r-pkgs.had.co.nz, but in short:

0. Load the `usethis` package to scaffold the boring parts of setting up unit tests.
1. Run `use_testthat` to configure the package for unit testing with `testthat`. This will update the `DESCRIPTION` file, create the `tests/testthat` folder and the `tests/testthat.R` file.
2. Run `use_test('euro')` to generate `tests/testthat/test-euro.R`.
3. Edit the `test-euro.R` file to write an actual test:

    ```r
    test_that("euro sign added", {
      expect_equal(euro(2), '€2')
    })
    ```

4. Run the test via `devtools::test()`
5. Check test coverage via `devtools::test_coverage()`

Check out some of the relevant advanced topics, e.g.

* implementing automatically running the tests via GitHub Actions for future pushes in the repo
* mock API calls, see e.g. https://r-pkgs.org/testing-advanced.html#mocking

### Recap of week 2

* revisit retries and caching
* further API integrations
* unit testing

It is recommended to install the current version of `mr`:

```r
devtools::install_github('daroczig/CEU-R-mastering-demo-pkg@week2')
```

### Homework for week 2 gotchas

[![A QA engineer walks into a bar. Orders a beer. Orders 0 beers. Orders 99999999999 beers. Orders a lizard. Orders -1 beers. Orders a ueicbksjdhd. First real customer walks in and asks where the bathroom is. The bar bursts into flames, killing everyone.](https://github.com/daroczig/CEU-R-mastering/assets/495736/18d88b52-fd09-4ee0-91a1-8b96e062f89c)](https://twitter.com/brenankeller/status/1068615953989087232)

### Report on the price of 0.42 BTC and 1.2 ETH in the past 30 days

Let's do the same report as above, but now we not only have 0.42 Bitcoin, but 1.2 Ethereum as well.

<details>
  <summary>Click here for a potential solution ...</summary>

```r
library(binancer)
library(data.table)
library(ggplot2)
library(mr)

## ########################################################
## CONSTANTS

BITCOINS  <- 0.42
ETHEREUMS <- 1.2

## ########################################################
## Loading data

usdeurs <- get_usdeurs(start_date = Sys.Date() - 30, end_date = Sys.Date())

## Cryptocurrency prices in USD
btcusdt <- binance_klines('BTCUSDT', interval = '1d', limit = 30)
ethusdt <- binance_klines('ETHUSDT', interval = '1d', limit = 30)
coinusdt <- rbind(btcusdt, ethusdt)
str(coinusdt)
## oh no, how to keep the symbol??
coinusdt[, .(date = as.Date(close_time), btcusd = close, symbol = ???)]

## DRY (don't repeat yourself)
balance <- rbindlist(lapply(c('BTC', 'ETH'), function(s) {
  binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[, .(
    date = as.Date(close_time),
    usdt = close,
    symbol = s
  )]
}))

balance <- balance[, amount := switch(
  symbol,
  'BTC' = BITCOINS,
  'ETH' = ETHEREUMS,
  stop('Unsupported coin')),
  by = symbol]
str(balance)

balance <- merge(balance, usdeurs, by = 'date')
balance[, value := amount * usdt * usdeur]
str(balance)

## ########################################################
## Report

ggplot(balance, aes(date, value, fill = symbol)) +
  geom_col() +
  xlab('') +
  ylab('') +
  scale_y_continuous(labels = euro) +
  theme_bw() +
  ggtitle(
    'My crypto fortune',
    subtitle = balance[date == max(date), paste(paste(amount, symbol), collapse = ' + ')])
```

</details>

### Report on the price of cryptocurrency assets read from a database

1. 💪 Create a new MySQL database at Amazon AWS and don't forget to set an "inital database name" and make it publicly accessible.

2. Log in and give a try with MySQL client:

    ```shell
    mysql -h mr.cf27iwlo5bzr.eu-west-1.rds.amazonaws.com -u admin -p
    ```

    Look around:

    ```shell
    show databases;
    use crypto;
    show tables;
    desc coins;
    select * FROM coins;
    ```

3. 💪 Install `dbr` from GitHub:

    ```r
    library(devtools)
    install_github('daroczig/logger')
    install_github('daroczig/dbr')
    ```

4. 💪 Install `botor` as well to be able to use encrypted credentials (note that this requires you to install Python first and then `pip install boto3` as well):

    ```r
    install_github('daroczig/botor')
    ```

5. Set up a YAML file (menu: new file/text file, save as `databases.yml`) for the database connection, something like:

   ```shell
   remotemysql:
     host: ...
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

7. 💪 Create a table for the balances and insert some records:

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
    library(data.table)
    library(logger)
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

    ## USD in EUR
    usdeurs <- get_usdeurs(start_date = Sys.Date() - 30, end_date = Sys.Date())

    ## join USD/HUF exchange rate to balances
    balance <- merge(balance, usdeurs, by = 'date')
    balance[, value := amount * usdt * usdeur]

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

💪 Let's prepare the transactions table:

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
db_query('INSERT INTO transactions VALUES ("2023-05-11 10:42:02", "BTC", 1.42)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2023-05-11 10:45:20", "ETH", 1.2)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2023-05-18", "BTC", -1)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2023-05-23", "NEO", 100)', 'remotemysql')
db_query('INSERT INTO transactions VALUES ("2023-05-30 12:12:21", "LTC", 25)', 'remotemysql')
```

<details>
  <summary>Click here for a potential solution for the report ...</summary>

```r
library(binancer)
library(data.table)
library(logger)
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
balance <- na.locf(balance, na.rm = FALSE)

## Fill in remaining missing values with zero
balance[is.na(balance)] <- 0

## Transform wide table back to long format
balance <- melt(balance, id.vars = 'date', variable.name = 'symbol', value.name = 'amount')
balance

## Get crypto prices
prices <- rbindlist(lapply(as.character(unique(balance$symbol)), function(s) {
    binance_klines(paste0(s, 'USDT'), interval = '1d', limit = 30)[
      , .(date = as.Date(close_time), symbol = s, usdt = close)]
}))
balance <- merge(balance, prices, by = c('date', 'symbol'), all.x = TRUE, all.y = FALSE)

## USD in EUR
usdeurs <- get_usdeurs(start_date = Sys.Date() - 30, end_date = Sys.Date())

## join USD/HUF exchange rate to balances
balance <- merge(balance, usdeurs, by = 'date')
balance[, value := amount * usdt * usdeur]

## compute daily values in HUF
balance[, value := amount * usdt * usdhuf]

## ########################################################
## Report

ggplot(balance, aes(date, value, fill = symbol)) +
    geom_col() +
    ylab('') + scale_y_continuous(labels = euro) +
    xlab('') +
    theme_bw() +
    ggtitle(
        'My crypto fortune',
        subtitle = balance[date == max(date), paste(paste(amount, symbol), collapse = ' + ')])
```

</details>

## Profiling, benchmarks

Breaking down the a single run of the `get_usdhuf` function to see which component is slow and taking up resources:

```r
library(mr)

library(profvis)
profvis({
  get_usdeur()
})

profvis({
  get_usdhuf()
}, interval = 0.005)
```

A more realistic example: is `ggplot2` indeed slow when generating scatter plots on a dataset with larger number of observations?

Note first run for the `library` call! Then run again.

```r
profvis({
  library(ggplot2)
  x <- ggplot(diamonds, aes(price, carat)) + geom_point()
  print(x)
})

system.time(x <- ggplot(diamonds, aes(price, carat)) + geom_point())
```

Pipe VS Bracket:

```r
library(data.table)
library(dplyr)
dt <- data.table(diamonds)
profvis({
  dt[, sum(carat), by = color][order(color)]
  group_by(dt, color) %>% summarise(price = sum(carat))
})
## run too quickly for profiling ...

library(microbenchmark)
results <- microbenchmark(
  aggregate(dt$carat, by = list(dt$color), FUN = sum),
  dt[, sum(carat), by = color][order(color)],
  group_by(dt, color) %>% summarise(price = sum(carat)),
  times = 100)

results
plot(results)
autoplot(results)

library(bench)
## needs to make sure that resulting objects are the same
results <- bench::mark(
  as.data.frame(dt[, .(price = sum(carat)), by = color][order(color)]),
  as.data.frame(group_by(dt, color) %>% summarize(price = sum(carat)))
)

results
autoplot(results)

## revisit benchmarking creating and printing ggplot
results <- microbenchmark(
  x <- ggplot(diamonds, aes(price, carat)) + geom_point(),
  print(x),
  times = 10)
```

Also check out `dtplyr`!

More examples at https://rstudio.github.io/profvis/examples.html

## Reporting exercises

### Connecting to and exploring the SQLite database

Download and extract the database file:

```r
## download database file
download.file('http://bit.ly/CEU-R-ecommerce', 'ecommerce.zip', mode = 'wb')
unzip('ecommerce.zip')
```

Install the SQLite client on your operating system and then use the `sqlite3 ecommerce.sqlite3` command to enter the command-line SQLite client to browse the database:

```sql
-- list tables in the database
.tables
-- show the structure of the sales table
.schema sales
-- show the first 5 rows of the table
select * from sales limit 5
-- tweak how the rows are shown
.headers on
.mode column
select * from sales limit 5

-- count number of rows in the table
SELECT COUNT(*) FROM sales;

-- count number of rows in January 2011 (lack of proper date/time handling in SQLite)
SELECT COUNT(*)
FROM sales
WHERE SUBSTR(InvoiceDate, 7, 4) || SUBSTR(InvoiceDate, 1, 2) || SUBSTR(InvoiceDate, 4, 2)
      BETWEEN '20110101' AND '20110131'

-- check on the date format
SELECT InvoiceDate FROM sales ORDER BY random() LIMIT 25;

-- count the number of rows per month
SELECT
  SUBSTR(InvoiceDate, 7, 4) || SUBSTR(InvoiceDate, 1, 2) AS month,
  COUNT(*)
FROM sales
GROUP BY month
ORDER BY month;
```

Let's switch to R!

### Connect to SQLite from R

Create a database config file for the `dbr` package:

```yaml
ecommerce:
  drv: !expr RSQLite::SQLite()
  dbname: /path/to/ecommerce.sqlite3
```

Update your `dbr` settings to use the config file:

```r
library(dbr)
options('dbr.db_config_path' = '/path/to/database.yml')
options('dbr.output_format' = 'data.table')

sales <- db_query('SELECT * FROM sales', 'ecommerce')
str(sales)

## explore and fix the invoice date column
sales[, sample(InvoiceDate, 25)]
sales[, InvoiceDate := as.POSIXct(InvoiceDate, format = '%m/%d/%Y %H:%M')]
## see fasttime::fastPOSIXct

## number of sales per month like in SQL
library(lubridate)
sales[, .N, by = month(InvoiceDate)]
sales[, .N, by = year(InvoiceDate)]
sales[, .N, by = paste(year(InvoiceDate), month(InvoiceDate))]
# slow
sales[, .N, by = as.character(InvoiceDate, format = '%Y %m')]
# smart
sales[, .N, by = floor_date(InvoiceDate, 'month')]

system.time(sales[, .N, by = as.character(InvoiceDate, format = '%Y %m')])
system.time(sales[, .N, by = floor_date(InvoiceDate, 'month')])

library(microbenchmark)
microbenchmark(
  sales[, .N, by = as.character(InvoiceDate, format = '%Y %m')],
  sales[, .N, by = floor_date(InvoiceDate, 'month')],
  times = 10)

## number of items per country
sales[, .N, by = Country]
sales[, .N, by = Country][order(-N)]
```

### Aggregate transaction items into invoice summary

```r
invoices <- sales[, .(date = min(as.Date(InvoiceDate)),
                      value  = sum(Quantity * UnitPrice)),
                  by = .(invoice = InvoiceNo, customer = CustomerID, country = Country)]

db_insert(invoices, 'invoices', 'ecommerce')
```

Check the structure of the newly (and automatically) created table using the command-line SQLite client:

```sql
.schema invoices
```

Check the date column after reading back from the database:

```r
invoices <- db_query('SELECT * FROM invoices', 'ecommerce')
str(invoices)

invoices[, date := as.Date(date, origin = '1970-01-01')]
```

### Report the daily revenue in Excel

```r
revenue <- invoices[, .(revenue = sum(value)), by = date]

library(openxlsx)
wb <- createWorkbook()
sheet <- 'Revenue'
addWorksheet(wb, sheet)
writeData(wb, sheet, revenue)

## open for quick check
openXL(wb)

## write to a file to be sent in an e-mail, uploaded to Slack or as a Google Spreasheet etc
filename <- tempfile(fileext = '.xlsx')
saveWorkbook(wb, filename)
unlink(filename)

## static file name
filename <- 'report.xlsx'
saveWorkbook(wb, filename)
```

Tweak that spreadsheet:

```r
freezePane(wb, sheet, firstRow = TRUE)

setColWidths(wb, sheet, 1:ncol(revenue), 'auto')

poundStyle <- createStyle(numFmt = '£0,000.00')
addStyle(wb, sheet = sheet, poundStyle,
         gridExpand = TRUE, cols = 2, rows = (1:nrow(revenue)) + 1, stack = TRUE)

greenStyle <- createStyle(fontColour = "#00FF00") # previously? fgFill = "#00FF00"
conditionalFormatting(wb, sheet, cols = 2,
                      rows = 2:(nrow(revenue) + 1),
                      rule = '$B2>66788.35', style = greenStyle)

standardStyle <- createStyle()
conditionalFormatting(wb, sheet, cols = 2,
                      rows = 2:(nrow(revenue) + 1),
                      rule = '$B2<=66788.35', style = standardStyle)
```

Add a plot:

```r
addWorksheet(wb, 'Plot')

library(ggplot2)
library(ggthemes)
ggplot(revenue, aes(date, revenue)) + geom_line() + theme_excel()

insertPlot(wb, 'Plot')

saveWorkbook(wb, filename)
saveWorkbook(wb, filename,  overwrite = TRUE)
```

### Report the monthly revenue and daily breakdowns in Excel

```r
library(lubridate)
monthly <- invoices[, .(value = sum(value)), by = .(month = floor_date(date, 'month'))]

library(openxlsx)
wb <- createWorkbook()
sheet <- 'Summary'
addWorksheet(wb, sheet)
writeData(wb, sheet, monthly)

for (month in as.character(monthly$month)) {
  revenue <- invoices[floor_date(date, 'month') == month,
                      .(revenue = sum(value)), by = date]
  addWorksheet(wb, as.character(month))
  writeData(wb, month, revenue)
}

saveWorkbook(wb, 'monthly-report.xlsx')
```

### Report on the top 10 customers in a Google Spreadsheet

```r
top10 <- sales[!is.na(CustomerID),
               .(revenue = sum(UnitPrice * Quantity)), by = CustomerID][order(-revenue)][1:10]

library(openxlsx)
wb <- createWorkbook()
sheet <- 'Top Customers'
addWorksheet(wb, sheet)
writeData(wb, sheet, top10)
t <- tempfile(fileext = '.xlsx')
saveWorkbook(wb, t)

## upload file
library(googledrive)
drive_auth()
## NOTE you can clean up credentials in ~/.R/gargle/gargle-oauth
drive_upload(media = t, name = 'top customers', path = 'ceu')
drive_update(media = t, file = 'top customers')

## instead of top10, let's do top25 ... so appending a few rows to an already existing spreadsheet
top25 <- sales[
  !is.na(CustomerID),
  .(revenue = sum(UnitPrice * Quantity)), by = CustomerID][order(-revenue)][1:25]
library(googlesheets4)
gs4_auth()
for (i in 11:25) {
  sheet_append('your.spreadsheet.id', data = top25[i])
}
```

## Homeworks

### Week 1

Add the `get_usdeur` and `get_bitcoin_price` functions to your `mr` R package (including documentation and all required imports), and push to your GitHub repo, so that you can install the package on any computer via `remotes::install_github`. Submit the URL to your GitHub repo in Moodle.

### Week 2

Write unit tests for the `get_usdeurs` function, e.g. what happens when end date is lower than the start date, when he dates are not valid dates. Create a pull request for the main repo, and share the URL on Moodle.

### Week 3

Use GitHub Actions to either run the unit tests of the package after each push to GitHub, or to build documentation and publish using GitHub Pages.

References:

* https://r-pkgs.org/software-development-practices.html#sec-sw-dev-practices-ci
* https://r-pkgs.org/website.html

Share the URL of a successful GitHub Actions run on Moodle.

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-mastering/issues).
