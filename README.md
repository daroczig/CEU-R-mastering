This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/2022-2023/mastering-r-skills)" course in the 2022/2023 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous edition, see [2018/2019 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2018-2019), [2019/2020 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2019-2020), and [2020/2021 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2020-2021).

## Table of Contents

* [Schedule](#schedule)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class materials](#class-materials)
  * [API ingest and data transformation exercises](#api-ingest-and-data-transformation-exercises)
     * [Report on the current price of 0.42 BTC](#report-on-the-current-price-of-042-btc)
     * [Report on the current price of 0.42 BTC in HUF](#report-on-the-current-price-of-042-btc-in-huf)
     * [Move helpers to a new R package](#move-helpers-to-a-new-r-package)
     * [Report on the price of 0.42 BTC in the past 30 days](#report-on-the-price-of-042-btc-in-the-past-30-days)
     * [Report on the price of 0.42 BTC and 1.2 ETH in the past 30 days](#report-on-the-price-of-042-btc-and-12-eth-in-the-past-30-days)
     * [Report on the price of cryptocurrency assets read from a database](#report-on-the-price-of-cryptocurrency-assets-read-from-a-database)
     * [Report on the price of cryptocurrency assets based on the transaction history read from a database](#report-on-the-price-of-cryptocurrency-assets-based-on-the-transaction-history-read-from-a-database)
  * [Profiling, benchmarks](#profiling-benchmarks)
  * [Reporting exercises](#reporting-exercises)
     * [Connecting to and exploring the SQLite database](#connecting-to-and-exploring-the-sqlite-database)
     * [Connect to SQLite from R](#connect-to-sqlite-from-r)
     * [Aggregate transaction items into invoice summary](#aggregate-transaction-items-into-invoice-summary)
     * [Report the daily revenue in Excel](#report-the-daily-revenue-in-excel)
     * [Report the monthly revenue and daily breakdowns in Excel](#report-the-monthly-revenue-and-daily-breakdowns-in-excel)
     * [Report on the top 10 customers in a Google Spreadsheet](#report-on-the-top-10-customers-in-a-google-spreadsheet)
* [Home assignment](#homeworks)
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

    If you get stuck, feel free to use the preconfigured, shared RStudio Server at http://mr.ceudata.net (I will share the usernames and passwords at the start of the class). In such case, you can skip all the steps prefixed with "💪" as the server already have that configured.

2. Join the #ba-mr-2022 Slack channel in the `ceu-bizanalytics` Slack group.
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
  <summary>Click here for a hint ...</summary>

  We installed the `binancer` package for a reason! Look up the related functions via `help(package = binancer)`.
</details>

## Contact

File a [GitHub ticket](https://github.com/daroczig/CEU-R-mastering/issues).
