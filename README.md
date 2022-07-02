
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

    ## # A tibble: 2,506 × 3
    ##    market name             code 
    ##    <chr>  <chr>            <chr>
    ##  1 stock  동화약품         00002
    ##  2 stock  KR모터스         00004
    ##  3 stock  경방             00005
    ##  4 stock  메리츠화재       00006
    ##  5 stock  삼양홀딩스       00007
    ##  6 stock  하이트진로       00008
    ##  7 stock  유한양행         00010
    ##  8 stock  CJ대한통운       00012
    ##  9 stock  하이트진로홀딩스 00014
    ## 10 stock  두산             00015
    ## # … with 2,496 more rows

``` r
sscode <- code[grep("^삼성전자$", code$name),3]
sscode
```

    ## # A tibble: 1 × 1
    ##   code 
    ##   <chr>
    ## 1 00593

``` r
samsung <- tqk_get(sscode, from="2018-05-01")
```

    ## No encoding supplied: defaulting to UTF-8.

``` r
samsung
```

    ## NULL

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
```

    ## No encoding supplied: defaulting to UTF-8.

``` r
ss
```

    ## NULL

## 설치

``` r
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("mrchypark/tqk")
library(tqk)
```
