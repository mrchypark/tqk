#' Get quantitative data from korea
#'
#' @return a [tibble][tibble::tibble-package]
#' @param x Stock x. only Korean type like "005930" is samsung.
#' @param from Optional for various time series functions. A character string representing a start date in YYYY-MM-DD format.
#' @param to Optional for various time series functions. A character string representing a end date in YYYY-MM-DD format.
#' @param auth_key KRX OPEN API AUTH_KEY. If omitted, uses `Sys.getenv("KRX_AUTH_KEY")`.
#' @param sample Use sample endpoints (`/svc/sample/apis`). When `TRUE`, public sample key is used if `auth_key` is empty.
#' @export
#' @examples
#' \donttest{
#'   tqk_get(x = "088980", sample = TRUE)
#'   tqk_get(x = "088980", from = "2024-01-02", to = "2024-01-05", sample = TRUE)
#' }
#' @importFrom tibble as_tibble
#' @importFrom dplyr transmute bind_rows
tqk_get <- function(x,
                    from = Sys.Date() - 7,
                    to = Sys.Date(),
                    auth_key = Sys.getenv("KRX_AUTH_KEY", unset = ""),
                    sample = FALSE) {
  . <-
    BAS_DD <-
    ISU_CD <-
    TDD_OPNPRC <-
    TDD_HGPRC <-
    TDD_LWPRC <-
    TDD_CLSPRC <-
    ACC_TRDVOL <- NULL

  x <- as.character(x)
  stopifnot(valid_code_format(x))

  from_date <- as_krx_date(from, arg_name = "from")
  to_date <- as_krx_date(to, arg_name = "to")
  if (from_date > to_date) {
    stop("`from` must be earlier than or equal to `to`.", call. = FALSE)
  }

  codes <- krcodedata
  if (!check_code_exist(x)) {
    codes <- tryCatch(
      code_get(
        fresh = TRUE,
        auth_key = auth_key,
        sample = sample,
        bas_dd = to_date
      ),
      error = function(e) {
        warning(
          sprintf(
            "Failed to refresh stock codes, using cached data. Reason: %s",
            conditionMessage(e)
          ),
          call. = FALSE
        )
        krcodedata
      }
    )
  }
  if (!(x %in% codes$code)) {
    stop(sprintf("Code '%s' is not found in KRX stock list.", x), call. = FALSE)
  }

  market <- as.character(codes[codes$code == x, "market"][[1]])
  if (!market %in% names(.krx_openapi_trade_api_ids)) {
    stop(sprintf("Market '%s' is not supported by stock daily API.", market), call. = FALSE)
  }
  api_id <- unname(.krx_openapi_trade_api_ids[[market]])

  days <- seq.Date(from_date, to_date, by = "day")
  if (length(days) > 92) {
    warning(
      "OPEN API stock endpoints are queried per day. Large ranges may take a long time.",
      call. = FALSE
    )
  }

  output <- lapply(days, function(day) {
    payload <- .krx_openapi_get(
      api_id = api_id,
      query = list(basDd = format(day, "%Y%m%d")),
      auth_key = auth_key,
      sample = sample
    )

    if (is.null(payload$OutBlock_1) || length(payload$OutBlock_1) == 0) {
      return(NULL)
    }
    rows <- tibble::as_tibble(payload$OutBlock_1)
    if (!"ISU_CD" %in% names(rows)) {
      return(NULL)
    }
    rows[rows$ISU_CD == x, , drop = FALSE]
  })

  result <- dplyr::bind_rows(output)
  if (nrow(result) == 0) {
    return(empty_price_tbl())
  }

  dplyr::transmute(
    result,
    date = as.Date(BAS_DD, format = "%Y%m%d"),
    open = to_int(TDD_OPNPRC),
    high = to_int(TDD_HGPRC),
    low = to_int(TDD_LWPRC),
    close = to_int(TDD_CLSPRC),
    volume = to_int(ACC_TRDVOL)
  )
}
