
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
install.packages('tqk', repos = c(
                     'https://mrchypark.r-universe.dev',
                     'https://cloud.r-project.org'
                 ))
```

## How to use

### Stock code

`code_get()` function provide stock code.

``` r
code_get()
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
    ## # ℹ 2,631 more rows

If want to get current version of stock code, add `fresh = TRUE`.

``` r
code_get(fresh = TRUE)
```

    ## # A tibble: 2,748 × 6
    ##    market name           code   name_full              name_eng        code_full
    ##    <chr>  <chr>          <chr>  <chr>                  <chr>           <chr>    
    ##  1 KOSDAQ 마이크로컨텍솔 098120 (주)마이크로컨텍솔루션 Micro Contact … KR709812…
    ##  2 KOSDAQ 포스코엠텍     009520 (주)포스코엠텍         POSCO M-TECH C… KR700952…
    ##  3 KOSPI  AJ네트웍스     095570 AJ네트웍스보통주       AJ Networks Co… KR709557…
    ##  4 KOSPI  AK홀딩스       006840 AK홀딩스보통주         AK Holdings, I… KR700684…
    ##  5 KOSPI  BGF리테일      282330 BGF리테일보통주        BGF Retail      KR728233…
    ##  6 KOSPI  BGF            027410 BGF보통주              BGF             KR702741…
    ##  7 KOSPI  BNK금융지주    138930 BNK금융지주보통주      BNK Financial … KR713893…
    ##  8 KOSPI  BYC우          001465 BYC1우선주             BYC(1P)         KR700146…
    ##  9 KOSPI  BYC            001460 BYC보통주              BYC             KR700146…
    ## 10 KOSPI  CJ우           001045 CJ1우선주              CJ(1P)          KR700104…
    ## # ℹ 2,738 more rows

### Stock data

`tqk_get()` function provide stock data. First parameter named `x` is
korean stock code like “005930” is samsung. Result of `code_get()`
function has `code` column for `x` parameter on `tqk_get()` function.

``` r
code_get() %>% 
  dplyr::filter("삼성전자" == name) %>%
  dplyr::pull(code) %>% 
  tqk_get(from = "2018-05-01") -> ss
ss
```

    ## # A tibble: 1,312 × 6
    ##    date        open  high   low close   volume
    ##    <date>     <int> <int> <int> <int>    <int>
    ##  1 2023-08-25 67100 67400 66900 67100  7032462
    ##  2 2023-08-24 68300 68700 67900 68200 15044463
    ##  3 2023-08-23 66700 67100 66400 67100  9549352
    ##  4 2023-08-22 67200 67700 66300 66600 10500242
    ##  5 2023-08-21 66600 67100 66300 66600  9720067
    ##  6 2023-08-18 66000 66700 65800 66300 11745006
    ##  7 2023-08-17 66300 66800 66000 66700 10778652
    ##  8 2023-08-16 66700 67100 66300 67000 13174578
    ##  9 2023-08-14 67500 67900 66900 67300  9352343
    ## 10 2023-08-11 68400 68800 67500 67500  9781038
    ## # ℹ 1,302 more rows

## Built-in dataset

`{tqk}` has built-in dataset called `SHANK` that is data to `2017-09-07`
with Samsung Elect, Hyundai Motor, Amore pacific, Naver, Kakao.

``` r
SHANK %>%
  dplyr::distinct(symbol)
```

    ## # A tibble: 5 × 1
    ##   symbol
    ##   <chr> 
    ## 1 SS    
    ## 2 HYD   
    ## 3 AMP   
    ## 4 NVR   
    ## 5 KKO

``` r
SHANK
```

    ## # A tibble: 22,259 × 7
    ##    symbol date          open    high     low   close volume
    ##    <chr>  <date>       <int>   <int>   <int>   <int>  <int>
    ##  1 SS     2017-09-07 2350000 2411000 2350000 2406000 193530
    ##  2 SS     2017-09-06 2338000 2359000 2335000 2350000 216221
    ##  3 SS     2017-09-05 2312000 2345000 2298000 2338000 234322
    ##  4 SS     2017-09-04 2289000 2318000 2275000 2302000 158870
    ##  5 SS     2017-09-01 2323000 2332000 2315000 2324000 212834
    ##  6 SS     2017-08-31 2311000 2332000 2300000 2316000 220234
    ##  7 SS     2017-08-30 2319000 2320000 2298000 2310000 150260
    ##  8 SS     2017-08-29 2282000 2304000 2258000 2304000 252473
    ##  9 SS     2017-08-28 2351000 2362000 2298000 2305000 199242
    ## 10 SS     2017-08-25 2394000 2394000 2336000 2351000 224871
    ## # ℹ 22,249 more rows
