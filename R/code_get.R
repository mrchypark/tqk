#' Get company code
#'
#' Get code for korea finance market
#'
#' @param fresh get code on internet. Default is FALSE.
#' @param auth_key KRX OPEN API AUTH_KEY. If omitted, uses `Sys.getenv("KRX_AUTH_KEY")`.
#' @param sample Use sample endpoints (`/svc/sample/apis`). When `TRUE`, public sample key is used if `auth_key` is empty.
#' @param bas_dd Base date used for OPEN API query. Supports `Date`, `YYYY-MM-DD`, `YYYYMMDD`.
#' @return a [tibble][tibble::tibble-package] with market, name, code column.
#' @export
#' @examples
#' \donttest{
#'   code_get()
#'   code_get(fresh = TRUE, sample = TRUE, bas_dd = "2024-01-02")
#' }
#' @importFrom tibble as_tibble
#' @importFrom dplyr transmute bind_rows distinct
code_get <- function(fresh = FALSE,
                     auth_key = Sys.getenv("KRX_AUTH_KEY", unset = ""),
                     sample = FALSE,
                     bas_dd = Sys.Date()) {
  if (!fresh) {
    return(krcodedata)
  }

  . <-
    code <-
    MKT_TP_NM <-
    ISU_ABBRV <-
    ISU_SRT_CD <-
    ISU_NM <-
    ISU_ENG_NM <-
    ISU_CD <- NULL

  bas_dd <- to_krx_date(bas_dd, arg_name = "bas_dd")

  output <- lapply(.krx_openapi_code_api_ids, function(api_id) {
    payload <- .krx_openapi_get(
      api_id = api_id,
      query = list(basDd = bas_dd),
      auth_key = auth_key,
      sample = sample
    )

    if (is.null(payload$OutBlock_1) || length(payload$OutBlock_1) == 0) {
      return(NULL)
    }
    tibble::as_tibble(payload$OutBlock_1)
  })

  all_codes <- dplyr::bind_rows(output)
  if (nrow(all_codes) == 0) {
    return(empty_code_tbl())
  }

  dplyr::transmute(
    all_codes,
    market = MKT_TP_NM,
    name = ISU_ABBRV,
    code = ISU_SRT_CD,
    name_full = ISU_NM,
    name_eng = ISU_ENG_NM,
    code_full = ISU_CD
  ) %>%
    dplyr::distinct(code, .keep_all = TRUE)
}
