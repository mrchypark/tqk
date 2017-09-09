tqk
================

스타는 더욱 많은 코드, 데이터 공개의 힘이 됩니다. ;)
----------------------------------------------------

tidyquant에서 한국 주가 정보 활용
---------------------------------

[tidyquant](https://github.com/business-science/tidyquant)가 활용하는 yahoo나 google 주식은 한국 주식 데이터가 유명한 것만 있어 주식 분석을 하는데 문제가 있습니다. 그래서 우리나라에서 대표적으로 주식 데이터를 제공하는 p, n, d 사등의 페이지를 가져오는 함수를 작성하여 배포합니다.(현재 p사만 적용중)

기능
----

1.  get\_code : 우리나라 주식시장의 code와 명칭, 소속 시장 정보를 가져옵니다.
2.  tqk\_get : code와 날짜를 기반으로 주식 정보를 가져옵니다. tidyquant 의 양식이 기본값이고 가져오는 데이터 형식 전체를 사용하고 싶으면 tqform=F 설정하시면 됩니다. tqform=T 일때 adjusted는 아직 close와 같은 값으로 계산식을 업데이트 해야 합니다.

사용법
------

``` r
library(tqk)
code<-code_get()
code
```

    ## # A tibble: 2,273 x 3
    ##      code                    name category
    ##     <chr>                   <chr>    <chr>
    ##  1 060310                      3S   KOSDAQ
    ##  2 095570              AJ네트웍스    KOSPI
    ##  3 068400                AJ렌터카    KOSPI
    ##  4 006840                AK홀딩스    KOSPI
    ##  5 054620               APS홀딩스   KOSDAQ
    ##  6 211270                  AP위성   KOSDAQ
    ##  7 152100             ARIRANG 200      ETF
    ##  8 222170 ARIRANG S&P한국배당성장      ETF
    ##  9 161490      ARIRANG 경기방어주      ETF
    ## 10 161500      ARIRANG 경기주도주      ETF
    ## # ... with 2,263 more rows

``` r
samsung<-tqk_get(code[grep("삼성전자", code[,2]),1]
                 , from="2017-01-01")
```

    ## [1] "please wait for getting data using internet."
    ## [1] "close and adjusted are same now."

``` r
samsung
```

    ## # A tibble: 188 x 7
    ##          date  open  high   low close volume adjusted
    ##        <date> <int> <int> <int> <int>  <dbl>    <int>
    ##  1 2017-01-02  2820  3035  2790  3000 478672     3000
    ##  2 2017-01-02  2820  3035  2790  3000 478672     3000
    ##  3 2017-01-03  3070  3070  2900  3030 309507     3030
    ##  4 2017-01-04  3030  3095  2980  3090 248971     3090
    ##  5 2017-01-05  3090  3300  3050  3090 928979     3090
    ##  6 2017-01-06  3090  3095  3015  3015 202702     3015
    ##  7 2017-01-09  3045  3090  2995  3010 125422     3010
    ##  8 2017-01-10  3010  3030  2900  2930 247850     2930
    ##  9 2017-01-11  2970  2985  2920  2930  92280     2930
    ## 10 2017-01-12  2935  2970  2880  2880 160546     2880
    ## # ... with 178 more rows

설치
----

``` r
if (!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("mrchypark/tqk")
library(tidyquant)
library(tqk)
```

사용 설명서
-----------

`tidyquant`의 [설명서](https://github.com/business-science/tidyquant) 일부를 번역하고 `tqk`를 적용하여 한국 주식을 예로 든 [문서](https://mrchypark.github.io/tqk/tidyquant-with-tqk.html)를 준비 했습니다.
