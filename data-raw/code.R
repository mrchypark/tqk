## code to prepare `code` dataset goes here

library(tqk)

code <- code_get(fresh = TRUE)

usethis::use_data(code, overwrite = TRUE, internal = TRUE)
