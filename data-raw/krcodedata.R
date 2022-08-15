## code to prepare `code` dataset goes here

library(tqk)

krcodedata <- code_get(fresh = TRUE)

usethis::use_data(krcodedata, overwrite = TRUE, internal = TRUE)
