
# tqk [<img src="man/figures/logo.png" align="right" height=140/>](https://mrchypark.github.io/tqk/index.html)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/mrchypark/tqk/workflows/R-CMD-check/badge.svg)](https://github.com/mrchypark/tqk/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/tqk)](https://CRAN.R-project.org/package=tqk)
[![runiverse-name](https://mrchypark.r-universe.dev/badges/:name)](https://mrchypark.r-universe.dev/)
[![runiverse-package](https://mrchypark.r-universe.dev/badges/tqk)](https://mrchypark.r-universe.dev/ui#packages)
[![metacran
downloads](https://cranlogs.r-pkg.org/badges/tqk)](https://cran.r-project.org/package=tqk)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/tqk)](https://cran.rstudio.com/package=tqk)
[![Codecov test
coverage](https://codecov.io/gh/mrchypark/tqk/branch/main/graph/badge.svg)](https://app.codecov.io/gh/mrchypark/tqk?branch=main)
<!-- badges: end -->

## Installation

``` r
# CRAN version NOT YET!!!
install.packages("tqk")

# Dev version
install.packages("tqk", repos = "https://mrchypark.r-universe.dev")
```

## How to use

``` r
library(tqk)
code <- code_get()
code
```

    ## # A tibble: 2,641 × 6
    ##    market name           code   name_full              name_eng        code_full
    ##    <chr>  <chr>          <chr>  <chr>                  <chr>           <chr>    
    ##  1 KOSDAQ 마이크로컨텍솔 098120 (주)마이크로컨텍솔루션 Micro Contact … KR709812…
    ##  2 KOSDAQ 스카이이앤엠   131100 (주)스카이이앤엠       SKY E&M Co., L… KR713110…
    ##  3 KOSDAQ 포스코엠텍     009520 (주)포스코엠텍         POSCO M-TECH C… KR700952…
    ##  4 KOSPI  AJ네트웍스     095570 AJ네트웍스보통주       AJ Networks Co… KR709557…
    ##  5 KOSPI  AK홀딩스       006840 AK홀딩스보통주         AK Holdings, I… KR700684…
    ##  6 KOSPI  BGF리테일      282330 BGF리테일보통주        BGF Retail      KR728233…
    ##  7 KOSPI  BGF            027410 BGF보통주              BGF             KR702741…
    ##  8 KOSPI  BNK금융지주    138930 BNK금융지주보통주      BNK Financial … KR713893…
    ##  9 KOSPI  BYC우          001465 BYC1우선주             BYC(1P)         KR700146…
    ## 10 KOSPI  BYC            001460 BYC보통주              BYC             KR700146…
    ## # … with 2,631 more rows

``` r
sscode <- code[grep("^삼성전자$", code$name),3]
sscode
```

    ## # A tibble: 1 × 1
    ##   code  
    ##   <chr> 
    ## 1 005930

``` r
samsung <- tqk_get(sscode, from = "2018-05-01")
samsung
```

    ## # A tibble: 1,056 × 6
    ##    date        open  high   low close   volume
    ##    <date>     <int> <int> <int> <int>    <int>
    ##  1 2022-08-12 59500 60700 59400 60200 10786658
    ##  2 2022-08-11 59600 60000 59300 59900 15141941
    ##  3 2022-08-10 58900 59200 58600 59100 18084349
    ##  4 2022-08-09 60600 60700 59600 60000 18251170
    ##  5 2022-08-08 61400 61400 60600 60800 11313150
    ##  6 2022-08-05 61700 61900 61200 61500  9567620
    ##  7 2022-08-04 61700 61800 61200 61500  9125439
    ##  8 2022-08-03 61600 61600 61000 61300 10053861
    ##  9 2022-08-02 61200 61900 61000 61700 13614895
    ## 10 2022-08-01 61000 61700 60300 61300 13154816
    ## # … with 1,046 more rows

``` r
library(tqk)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
code_get() %>% 
  filter(grepl("^삼성전자$", name)) %>% 
  select(code) %>% 
  tqk_get(from = "2018-05-01") -> ss
ss
```

    ## # A tibble: 1,056 × 6
    ##    date        open  high   low close   volume
    ##    <date>     <int> <int> <int> <int>    <int>
    ##  1 2022-08-12 59500 60700 59400 60200 10786658
    ##  2 2022-08-11 59600 60000 59300 59900 15141941
    ##  3 2022-08-10 58900 59200 58600 59100 18084349
    ##  4 2022-08-09 60600 60700 59600 60000 18251170
    ##  5 2022-08-08 61400 61400 60600 60800 11313150
    ##  6 2022-08-05 61700 61900 61200 61500  9567620
    ##  7 2022-08-04 61700 61800 61200 61500  9125439
    ##  8 2022-08-03 61600 61600 61000 61300 10053861
    ##  9 2022-08-02 61200 61900 61000 61700 13614895
    ## 10 2022-08-01 61000 61700 60300 61300 13154816
    ## # … with 1,046 more rows
