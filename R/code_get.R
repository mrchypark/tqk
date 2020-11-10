#' Get company code
#'
#' Get code for korea finance market
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_text
#' @importFrom stringr str_squish
#' @importFrom xml2 read_html
#' @importFrom httr POST content add_headers
#' @importFrom dplyr bind_rows as_tibble select
#' @importFrom purrr map_chr

code_get <- function() {

  httr::POST(
    "https://kind.krx.co.kr/corpgeneral/corpList.do?method=download&pageIndex=1&currentPageSize=5000&comAbbrv=&beginIndex=&orderMode=3&orderStat=D&isurCd=&repIsuSrtCd=&searchCodeType=&marketType=&searchType=13&industry=&fiscalYearEnd=all&comAbbrvTmp=&location=all"
  ) %>%
    httr::content() %>%
    rawToChar() %>%
    xml2::read_html() %>%
    rvest::html_nodes("td") %>%
    rvest::html_text() %>%
    stringr::str_squish() %>%
    matrix(ncol = 9, byrow = T) %>%
    dplyr::as_tibble() %>%
    dplyr::select(1, 2) ->
    dat

  httr::POST(
    "https://kind.krx.co.kr/corpgeneral/corpList.do?method=searchCorpList&pageIndex=1&currentPageSize=5000&comAbbrv=&beginIndex=&orderMode=3&orderStat=D&isurCd=&repIsuSrtCd=&searchCodeType=&marketType=&searchType=13&industry=&fiscalYearEnd=all&comAbbrvTmp=&location=all"
  ) %>%
    httr::content() %>%
    rvest::html_nodes("td.first") %>%
    xml2::xml_find_first("img") %>%
    rvest::html_attr("alt") ->
      market

    dplyr::tibble(market = market,
                  name = dat$V1,
                  code = dat$V2) %>%
    return()
}
