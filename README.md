
# tqk <img src="man/figures/logo.png" align="right" height=140/>

## 스타는 더욱 많은 코드, 데이터 공개의 힘이 됩니다. ;)

###### MIT 라이선스는 마음껏 쓰되, 출처를 표시해달라는 뜻입니다.

#### 사용하실 때 출처(링크 표기 가능)를 밝혀주시면 감사하겠습니다.

###### 문의는 [이슈](https://github.com/mrchypark/tqk/issues/new)로 남겨주세요.

###### [이슈](https://github.com/mrchypark/tqk/issues)로 남겨주시면 같은 문제를 겪는 분이 해결하는데 도움이 됩니다.

## 사용 설명서

`tidyquant`의 [설명서](https://github.com/business-science/tidyquant) 일부를
번역하고 `tqk`를 적용하여 한국 주식을 예로 든
[문서](https://mrchypark.github.io/tqk-docs/tidyquant-with-tqk.html)를
준비
했습니다.

### [사용 설명서 바로가기](https://mrchypark.github.io/tqk-docs/tidyquant-with-tqk.html)

## tidyquant에서 한국 주가 정보 활용

[tidyquant](https://github.com/business-science/tidyquant)가 활용하는 yahoo나
google 주식은 한국 주식 데이터가 유명한 것만 있어 주식 분석을 하는데 문제가 있습니다. 그래서 우리나라에서 대표적으로 주식
데이터를 제공하는 p, n, d 사등의 페이지를 가져오는 함수를 작성하여 배포합니다.(현재 p사만 적용중)

## 기능

1.  code\_get : 우리나라 주식시장의 code와 명칭, 소속 시장 정보를 가져옵니다.
2.  tqk\_get : code와 날짜를 기반으로 주식 정보를 가져옵니다. tidyquant 의 양식이 기본값이고 가져오는
    데이터 형식 전체를 사용하고 싶으면 tqform=F 설정하시면 됩니다. tqform=T 일때 adjusted는 아직
    close와 같은 값으로 계산식을 업데이트 해야 합니다.

## 사용법

``` r
library(tqk)
code<-code_get()
code
```

    ## # A tibble: 2,306 x 3
    ##    code   name                    category
    ##    <chr>  <chr>                   <chr>   
    ##  1 060310 3S                      KOSDAQ  
    ##  2 095570 AJ네트웍스              KOSPI   
    ##  3 068400 AJ렌터카                KOSPI   
    ##  4 006840 AK홀딩스                KOSPI   
    ##  5 054620 APS홀딩스               KOSDAQ  
    ##  6 265520 AP시스템                KOSDAQ  
    ##  7 211270 AP위성                  KOSDAQ  
    ##  8 152100 ARIRANG 200             ETF     
    ##  9 222170 ARIRANG S&P한국배당성장 ETF     
    ## 10 161490 ARIRANG 경기방어주      ETF     
    ## # ... with 2,296 more rows

``` r
sscode <- code[grep("삼성전자", code[,2]),1]
sscode
```

    ## # A tibble: 1 x 1
    ##   code  
    ##   <chr> 
    ## 1 060310

``` r
samsung<-tqk_get(sscode, from="2017-01-01")
```

    ## [1] "please wait for getting data using internet."
    ## [1] "close and adjusted are same now."

``` r
samsung
```

    ## # A tibble: 471 x 7
    ##    date        open  high   low close volume adjusted
    ##    <date>     <int> <int> <int> <int>  <dbl>    <int>
    ##  1 2017-01-02  2820  3035  2790  3000 478672     3000
    ##  2 2017-01-03  3070  3070  2900  3030 309507     3030
    ##  3 2017-01-04  3030  3095  2980  3090 248971     3090
    ##  4 2017-01-05  3090  3300  3050  3090 928979     3090
    ##  5 2017-01-06  3090  3095  3015  3015 202702     3015
    ##  6 2017-01-09  3045  3090  2995  3010 125422     3010
    ##  7 2017-01-10  3010  3030  2900  2930 247850     2930
    ##  8 2017-01-11  2970  2985  2920  2930  92280     2930
    ##  9 2017-01-12  2935  2970  2880  2880 160546     2880
    ## 10 2017-01-12  2935  2970  2880  2880 160546     2880
    ## # ... with 461 more rows

## 설치

``` r
if (!requireNamespace("remotes")) install.packages("remotes")
remotes::install_github("mrchypark/tqk")
library(tqk)
```
