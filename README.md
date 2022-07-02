
# tqk <img src="man/figures/logo.png" align="right" height=140/>

## 스타는 더욱 많은 코드, 데이터 공개의 힘이 됩니다. ;)

###### MIT 라이선스는 마음껏 쓰되, 출처를 표시해달라는 뜻입니다.

#### 사용하실 때 출처(링크 표기 가능)를 밝혀주시면 감사하겠습니다.

###### 문의는 [이슈](https://github.com/mrchypark/tqk/issues/new)로 남겨주세요.

###### [이슈](https://github.com/mrchypark/tqk/issues)로 남겨주시면 같은 문제를 겪는 분이 해결하는데 도움이 됩니다.

## tidyquant에서 한국 주가 정보 활용

[tidyquant](https://github.com/business-science/tidyquant)가 활용하는
yahoo나 google 주식은 한국 주식 데이터가 유명한 것만 있어 주식 분석을
하는데 문제가 있습니다. 그래서 우리나라에서 대표적으로 주식 데이터를
제공하는 p, n, d 사등의 페이지를 가져오는 함수를 작성하여
배포합니다.(현재 p사만 적용중)

## 설치

``` r
# CRAN version NOT YET!!!
install.packages("tqk")

# Dev version
install.packages("tqk", repos = "https://mrchypark.r-universe.dev")
```

## 기능

1.  code_get : 우리나라 주식시장의 code와 명칭, 소속 시장 정보를
    가져옵니다.
2.  tqk_get : code와 날짜를 기반으로 주식 정보를 가져옵니다. tidyquant
    의 양식이 기본값이고 가져오는 데이터 형식 전체를 사용하고 싶으면
    tqform=F 설정하시면 됩니다. tqform=T 일때 adjusted는 아직 close와
    같은 값으로 계산식을 업데이트 해야 합니다.

## 사용법

``` r
library(tqk)
code <- code_get()
code
```

    ## # A tibble: 2,630 × 6
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
    ## # … with 2,620 more rows

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

    ## # A tibble: 1,026 × 7
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
    ## # … with 1,016 more rows

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

    ## # A tibble: 1,026 × 7
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
    ## # … with 1,016 more rows
