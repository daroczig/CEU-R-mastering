This is the R script/materials repository of the "[Mastering R Skills](https://courses.ceu.edu/courses/2020-2021/mastering-r-skills)" course in the 2012/2021 Spring term, part of the [MSc in Business Analytics](https://courses.ceu.edu/programs/ms/master-science-business-analytics) at CEU. For the previous edition, see [2018/2019 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2018-2019), [2019/2020 Spring](https://github.com/daroczig/CEU-R-mastering/tree/2019-2020).

## Table of Contents

* [Schedule](#schedule)
* [Syllabus](#syllabus)
* [Location](#location)
* [Syllabus](#syllabus)
* [Technical Prerequisites](#technical-prerequisites)
* [Class materials](#class-materials)
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

To be uploaded after each class,

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
