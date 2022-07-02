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
  c("stockMkt", "kosdaqMkt", "konexMkt") %>%
  purrr::map_dfr( ~ get_corps_info(.x)) %>%
  return()
}

#' @importFrom rvest html_nodes html_text html_attr
#' @importFrom stringr str_sub
#' @importFrom httr POST content
#' @importFrom dplyr case_when
get_corps_info <- function(market) {
  market_name <- dplyr::case_when(
    market == "stockMkt" ~ "stock",
    market == "kosdaqMkt" ~ "kosdaq",
    market == "konexMkt" ~ "konex"
  )
  httr::POST(
    "https://kind.krx.co.kr/corpgeneral/corpList.do",
    body = list(
      method = "searchCorpList",
      pageIndex = 1,
      currentPageSize = 3000,
      fiscalYearEnd = "all",
      marketType = market,
      location = "all"
    )
  ) %>%
    httr::content() %>%
    rvest::html_nodes("td.first") -> stock

  stock %>%
    rvest::html_text() %>%
    trimws() -> name

  stock %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("onclick") %>%
    stringr::str_sub(22, 26) -> code

  return(
    tibble(
      market = market_name, name, code
    )
  )
}
