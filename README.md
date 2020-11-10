
# tqk <img src="man/figures/logo.png" align="right" height=140/>

## 스타는 더욱 많은 코드, 데이터 공개의 힘이 됩니다. ;)

###### MIT 라이선스는 마음껏 쓰되, 출처를 표시해달라는 뜻입니다.

#### 사용하실 때 출처(링크 표기 가능)를 밝혀주시면 감사하겠습니다.

###### 문의는 [이슈](https://github.com/mrchypark/tqk/issues/new)로 남겨주세요.

###### [이슈](https://github.com/mrchypark/tqk/issues)로 남겨주시면 같은 문제를 겪는 분이 해결하는데 도움이 됩니다.

## 사용 설명서

`tidyquant`의 [설명서](https://github.com/business-science/tidyquant)
일부를 번역하고 `tqk`를 적용하여 한국 주식을 예로 든
[문서](https://mrchypark.github.io/tqk/articles/tqk-introduce.html)를
준비 했습니다.

### [사용 설명서 바로가기](https://mrchypark.github.io/tqk/articles/tqk-introduce.html)

## tidyquant에서 한국 주가 정보 활용

[tidyquant](https://github.com/business-science/tidyquant)가 활용하는
yahoo나 google 주식은 한국 주식 데이터가 유명한 것만 있어 주식 분석을
하는데 문제가 있습니다. 그래서 우리나라에서 대표적으로 주식 데이터를
제공하는 p, n, d 사등의 페이지를 가져오는 함수를 작성하여
배포합니다.(현재 p사만 적용중)

## 기능

1.  code\_get : 우리나라 주식시장의 code와 명칭, 소속 시장 정보를
    가져옵니다.
2.  tqk\_get : code와 날짜를 기반으로 주식 정보를 가져옵니다. tidyquant
    의 양식이 기본값이고 가져오는 데이터 형식 전체를 사용하고 싶으면
    tqform=F 설정하시면 됩니다. tqform=T 일때 adjusted는 아직 close와
    같은 값으로 계산식을 업데이트 해야 합니다.

## 사용법

``` r
library(tqk)
code <- code_get()
```

    ## Warning: The `x` argument of `as_tibble.matrix()` must have unique column names if `.name_repair` is omitted as of tibble 2.0.0.
    ## Using compatibility `.name_repair`.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_warnings()` to see where this warning was generated.

``` r
code
```

    ## # A tibble: 2,386 x 3
    ##    market   name           code  
    ##    <chr>    <chr>          <chr> 
    ##  1 코스닥   소룩스         290690
    ##  2 코스닥   위드텍         348350
    ##  3 코스닥   센코           347000
    ##  4 코스닥   바이브컴퍼니   301300
    ##  5 코넥스   원포유         122830
    ##  6 코스닥   미코바이오메드 214610
    ##  7 코스닥   피플바이오     304840
    ##  8 유가증권 빅히트         352820
    ##  9 코스닥   넥스틴         348210
    ## 10 코스닥   원방테크       053080
    ## # ... with 2,376 more rows

``` r
sscode <- code[grep("^삼성전자$", code$name),3]
sscode
```

    ## # A tibble: 1 x 1
    ##   code  
    ##   <chr> 
    ## 1 005930

``` r
samsung <- tqk_get(sscode, from="2018-05-01")
samsung
```

    ## # A tibble: 621 x 7
    ##    date          open    high     low   close   volume adjusted
    ##    <date>       <dbl>   <dbl>   <dbl>   <dbl>    <int>    <dbl>
    ##  1 2018-05-02 2650000 2650000 2650000 2650000        0    53000
    ##  2 2018-05-03 2650000 2650000 2650000 2650000        0    53000
    ##  3 2018-05-04   53000   53900   51800   51900 39565391    51900
    ##  4 2018-05-08   52600   53200   51900   52600 23104720    52600
    ##  5 2018-05-09   52600   52800   50900   50900 16128305    50900
    ##  6 2018-05-10   51700   51700   50600   51600 13905263    51600
    ##  7 2018-05-11   52000   52200   51200   51300 10314997    51300
    ##  8 2018-05-14   51000   51100   49900   50100 14909272    50100
    ##  9 2018-05-15   50200   50400   49100   49200 18709146    49200
    ## 10 2018-05-16   49200   50200   49150   49850 15918683    49850
    ## # ... with 611 more rows

## 파이프 (`%>%`) 사용 with dplyr

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

    ## # A tibble: 621 x 7
    ##    date          open    high     low   close   volume adjusted
    ##    <date>       <dbl>   <dbl>   <dbl>   <dbl>    <int>    <dbl>
    ##  1 2018-05-02 2650000 2650000 2650000 2650000        0    53000
    ##  2 2018-05-03 2650000 2650000 2650000 2650000        0    53000
    ##  3 2018-05-04   53000   53900   51800   51900 39565391    51900
    ##  4 2018-05-08   52600   53200   51900   52600 23104720    52600
    ##  5 2018-05-09   52600   52800   50900   50900 16128305    50900
    ##  6 2018-05-10   51700   51700   50600   51600 13905263    51600
    ##  7 2018-05-11   52000   52200   51200   51300 10314997    51300
    ##  8 2018-05-14   51000   51100   49900   50100 14909272    50100
    ##  9 2018-05-15   50200   50400   49100   49200 18709146    49200
    ## 10 2018-05-16   49200   50200   49150   49850 15918683    49850
    ## # ... with 611 more rows

## 설치

``` r
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("mrchypark/tqk")
library(tqk)
```
