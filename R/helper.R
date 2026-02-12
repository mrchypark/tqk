to_int <- function(chr) {
  suppressWarnings(as.integer(gsub(",", "", chr)))
}

valid_code_format <- function(x) {
  x <- as.character(x)
  all(grepl("^[0-9]{6}$", x))
}

check_code_exist <- function(x) {
  x <- as.character(x)
  all(x %in% krcodedata$code)
}

as_krx_date <- function(x, arg_name = deparse(substitute(x))) {
  if (inherits(x, "Date")) {
    return(as.Date(x))
  }
  x <- as.character(x)[1]
  x <- gsub("-", "", x)
  if (!grepl("^[0-9]{8}$", x)) {
    stop(
      sprintf("`%s` must be in YYYY-MM-DD or YYYYMMDD format.", arg_name),
      call. = FALSE
    )
  }
  parsed <- as.Date(x, format = "%Y%m%d")
  if (is.na(parsed)) {
    stop(sprintf("`%s` is not a valid date.", arg_name), call. = FALSE)
  }
  parsed
}

to_krx_date <- function(x, arg_name = deparse(substitute(x))) {
  format(as_krx_date(x, arg_name = arg_name), "%Y%m%d")
}

empty_code_tbl <- function() {
  tibble::tibble(
    market = character(),
    name = character(),
    code = character(),
    name_full = character(),
    name_eng = character(),
    code_full = character()
  )
}

empty_price_tbl <- function() {
  tibble::tibble(
    date = as.Date(character()),
    open = integer(),
    high = integer(),
    low = integer(),
    close = integer(),
    volume = integer()
  )
}
