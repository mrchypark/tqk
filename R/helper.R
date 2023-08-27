to_int <- function(chr) {
  as.integer(gsub(",", "", chr))
}

valid_code_format <- function(x) {
  all(nchar(x) == 6,
      !any(is.na(suppressWarnings(as.numeric(strsplit(
        x, ""
      )[[1]])))))
}

check_code_exist <- function(x) {
  nrow(krcodedata[krcodedata$code == x, ]) == 1
}
