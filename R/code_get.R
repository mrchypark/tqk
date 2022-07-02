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
  jsonlite::fromJSON() %>%
  .$OutBlock_1 %>%
  tibble::as_tibble() %>%
  dplyr::select(
    -LIST_DD,
    -SECUGRP_NM,
    -SECT_TP_NM,
    -KIND_STKCERT_TP_NM,
    -PARVAL,
    -LIST_SHRS
    ) %>%
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

