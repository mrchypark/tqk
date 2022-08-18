
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
    ## # … with 2,631 more rows

If want to get current version of stock code, add `fresh = TRUE`.

``` r
code_get(fresh = TRUE)
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

    ## # A tibble: 1,059 × 6
    ##    date        open  high   low close   volume
    ##    <date>     <int> <int> <int> <int>    <int>
    ##  1 2022-08-18 60300 61100 60000 60900  9222166
    ##  2 2022-08-17 61100 61200 60300 60400  9061518
    ##  3 2022-08-16 60500 61600 60300 61000 15036727
    ##  4 2022-08-12 59500 60700 59400 60200 10786658
    ##  5 2022-08-11 59600 60000 59300 59900 15141941
    ##  6 2022-08-10 58900 59200 58600 59100 18084349
    ##  7 2022-08-09 60600 60700 59600 60000 18251170
    ##  8 2022-08-08 61400 61400 60600 60800 11313150
    ##  9 2022-08-05 61700 61900 61200 61500  9567620
    ## 10 2022-08-04 61700 61800 61200 61500  9125439
    ## # … with 1,049 more rows

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

    ## # A tibble: 6,895 × 8
    ##    symbol date          open    high     low   close volume adjusted
    ##    <chr>  <date>       <int>   <int>   <int>   <int>  <dbl>    <int>
    ##  1 SS     2012-02-08 1099000 1100000 1084000 1092000 236188  1092000
    ##  2 SS     2012-02-09 1087000 1090000 1060000 1084000 480117  1084000
    ##  3 SS     2012-02-10 1084000 1084000 1061000 1062000 371582  1062000
    ##  4 SS     2012-02-13 1069000 1089000 1067000 1083000 320345  1083000
    ##  5 SS     2012-02-14 1084000 1089000 1074000 1080000 246348  1080000
    ##  6 SS     2012-02-15 1098000 1138000 1092000 1135000 570447  1135000
    ##  7 SS     2012-02-16 1130000 1140000 1121000 1135000 308236  1135000
    ##  8 SS     2012-02-17 1159000 1180000 1156000 1176000 346169  1176000
    ##  9 SS     2012-02-20 1178000 1194000 1166000 1175000 296283  1175000
    ## 10 SS     2012-02-21 1175000 1198000 1165000 1180000 216165  1180000
    ## # … with 6,885 more rows
