This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/2020-2021/mastering-r-skills)" course in the 2012/2021 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous edition, see [2018/2019 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2018-2019), [2019/2020 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2019-2020).

## Table of Contents

* [Schedule](#schedule)
* [Syllabus](#syllabus)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class materials](#class-materials)
  * [API ingest and data transformation exercises](#api-ingest-and-data-transformation-exercises)
     * [Report on the current price of 0.42 BTC](#report-on-the-current-price-of-042-btc)
     * [Report on the current price of 0.42 BTC in HUF](#report-on-the-current-price-of-042-btc-in-huf)
     * [Move helpers to a new R package](#move-helpers-to-a-new-r-package)
* [Home assignment](#home-assignment)
* [References](#references)

## Schedule

3 x 200 mins on May 5, 12 and 19:

* 15:30 - 17:00 session 1
* 17:00 - 17:30 break
* 17:30 - 19:00 session 2

## Location

This class will take place online. Find the Zoom URL shared in Moodle.

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

2. Join the #ba-mastering-4-2020 Slack channel in the `ceu-bizanalytics` Slack group.
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

## Class materials

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
## https://api.exchangerate.host/latest
## https://api.exchangerate.host/latest?base=USD

readLines('https://api.exchangerate.host/latest?base=USD')

## Parse JSON
library(jsonlite)
fromJSON(readLines('https://api.exchangerate.host/latest?base=USD'))
fromJSON('https://api.exchangerate.host/latest?base=USD')

## Extract the USD/HUF exchange rate from the list
usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
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
usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF

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

usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
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

usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
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

get_usdhuf <- function() {
  tryCatch({
    usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
    assert_number(usdhuf, lower = 250, upper = 400)
  }, error = function(e) {
    ## str(e)
    log_error(e$message)
    Sys.sleep(1)
    get_usdhuf()
  })
  log_info('1 USD={usdhuf} HUF')
  usdhuf
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

log_info('{BITCOINS} Bitcoins now worth {round(get_bitcoin_price() * get_usdhuf() * BITCOINS)} HUF')
```

</details>

<details>
  <summary>Click here for a potential solution ... with auto-retries for API errors with exponential backoff</summary>

```r
get_usdhuf <- function(retried = 0) {
  tryCatch({
    ## httr
    usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
    assert_number(usdhuf, lower = 250, upper = 400)
  }, error = function(e) {
    ## str(e)
    log_error(e$message)
    Sys.sleep(1 + retried ^ 2)
    get_usdhuf(retried = retried + 1)
  })
  log_info('1 USD={usdhuf} HUF')
  usdhuf
}
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
forint(get_bitcoin_price() * get_usdhuf() * BITCOINS)
```

</details>


### Move helpers to a new R package

initial pkg version for saying hello

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

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
12. Add a new function that gets the most exchange rate for USD/HUF:

    <details>
      <summary><code>converter.R</code></summary>

    ```r
    #' Look up the value of a US Dollar in Hungarian Forints
    #' @param retried number of times the function already failed
    #' @return number
    #' @export
    #' @importFrom jsonlite fromJSON
    #' @importFrom logger log_error log_info
    #' @importFrom checkmate assert_number
    get_usdhuf <- function(retried = 0) {
      tryCatch({
        ## httr
        usdhuf <- fromJSON('https://api.exchangerate.host/latest?base=USD&symbols=HUF')$rates$HUF
        assert_number(usdhuf, lower = 250, upper = 400)
      }, error = function(e) {
        ## str(e)
        log_error(e$message)
        Sys.sleep(1 + retried ^ 2)
        get_usdhuf(retried = retried + 1)
      })
      log_info('1 USD={usdhuf} HUF')
      usdhuf
    }
    ```

    </details>

13. Now you can run the original R script hitting the Binance and ExchangeRatesAPI by using these helper functions:

```r
library(binancer)
library(logger)
log_threshold(TRACE)
library(scales)
library(mr)

BITCOINS <- 0.42
log_info('Number of Bitcoins: {BITCOINS}')

usdhuf <- get_usdhuf()

btcusd <- binance_coins_prices()[symbol == 'BTC', usd]
log_info('1 BTC={dollar(btcusd)}')

log_info('My crypto fortune is {forint(BITCOINS * btcusd * usdhuf)}')
```

Future materials will be uploaded after each class,

## References

* AWS Console: https://ceu.signin.aws.amazon.com/console
* Binance (cryptocurrency exchange) API: https://github.com/binance/binance-spot-api-docs/blob/master/rest-api.md (R implementation available at https://github.com/daroczig/binancer)
* Foreign exchange rates API, eg https://exchangerate.host
* "Writing R Extensions" docs: https://cran.r-project.org/doc/manuals/r-release/R-exts.html
* Hadley Wickham's "R packages" book: http://r-pkgs.had.co.nz
* Hadley Wickham's "Advanced R" book (1st edition): http://adv-r.had.co.nz/
* R package tests with GitHub Actions instead of Travis: https://github.com/r-lib/actions/tree/master/examples#quickstart-ci-workflow
* The `tidyverse` style guide: https://style.tidyverse.org/
* `pkgdown` package: https://pkgdown.r-lib.org/index.html
* `dbr` package: https://github.com/daroczig/dbr

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-mastering/issues).
