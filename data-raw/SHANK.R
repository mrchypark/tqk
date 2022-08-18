## code to prepare `SHANK` dataset goes here

library(tqk)
library(tidyr)

sam <- tqk_get("005930", to = "2017-09-07")
hyun <- tqk_get("005380", to = "2017-09-07")
amore <- tqk_get("090430", to = "2017-09-07")
naver <- tqk_get("035420", to = "2017-09-07")
kakao <- tqk_get("035720", to = "2017-09-07")

sam$symbol <- "SS"
hyun$symbol <- "HYD"
amore$symbol <- "AMP"
naver$symbol <- "NVR"
kakao$symbol <- "KKO"

SHANK <- rbind(sam, hyun, amore, naver, kakao)
SHANK <- SHANK %>% select(symbol, everything())

usethis::use_data(SHANK, overwrite = TRUE)
