#' Get company code
#'
#' Get code for korea finance market
#'
#' @param fresh get code on internet. Default is FALSE.
#' @return a [tibble][tibble::tibble-package] with market, name, code column.
#' @export
#' @importFrom httr POST content
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @importFrom dplyr transmute
code_get <- function(fresh = FALSE) {
  if (!fresh) {
    return(krcodedata)
  }
  . <-
    MKT_TP_NM <-
    ISU_ABBRV <-
    ISU_SRT_CD <- ISU_NM <- ISU_ENG_NM <- ISU_CD <- NULL

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
    jsonlite::fromJSON() %>%
    .$OutBlock_1 %>%
    tibble::as_tibble() %>%
    dplyr::transmute(
      market = MKT_TP_NM,
      name = ISU_ABBRV,
      code = ISU_SRT_CD,
      name_full = ISU_NM,
      name_eng = ISU_ENG_NM,
      code_full = ISU_CD
    ) %>%
    return()
}
