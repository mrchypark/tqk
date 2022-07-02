#' Get company code
#'
#' Get code for korea finance market
#'
#' @param fresh get code on internet. Default is FALSE.
#' @return a [tibble][tibble::tibble-package] with market, name, code column.
#' @export
#' @importFrom purrr map_dfr
code_get <- function(fresh = FALSE) {
  if (!fresh) {
    return(code)
  }
"http://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd" %>%
  httr::POST(
    body = list(
      bld = "dbms/MDC/STAT/standard/MDCSTAT01901",
      locale = "ko_KR",
      mktId = "ALL",
      share = 1,
      csvxls_isNo = "false"
    ),
    encode = "form"
  ) %>%
  httr::content("text") %>%
  jsonlite::fromJSON() -> res
  return(tibble::as_tibble(res$OutBlock_1))
}

