#' Get quantitative data from korea in `tibble` format
#'
#' @param code Stock code.
#' @param from Optional for various time series functions. A character string representing a start date in YYYY-MM-DD format.
#' @param to Optional for various time series functions. A character string representing a end date in YYYY-MM-DD format.
#' @param tqform transform data to tidyquant style.
#' @param source not use now.
#' @export
#' @importFrom curl curl_fetch_memory
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
#' @importFrom tibble as.tibble

tqk_get <-
  function(code,
           from = "1900-01-01",
           to = Sys.Date(),
           tqform = T,
           source = c("p", "d", "n")) {
    . <- NULL
    # todo
    # now just use p source only
    print("please wait for getting data using internet.")
    print("close and adjusted are same now.")
    root <-
      "http://paxnet.moneta.co.kr/stock/analysis/pagingListAjax?method=listByDate&abbrSymbol="
    tar <- paste0(root, code, "&currentPageNo=1")

    mpn <- curl::curl_fetch_memory(tar) %>%
      .$content %>%
      rawToChar() %>%
      jsonlite::fromJSON() %>%
      .$analysisSearchVO %>%
      .$lastPageNo

    pn <- 1:mpn

    tars <- paste0(root, code, "&currentPageNo=", pn)
    cont <- list()
    for (i in 1:length(tars)) {
      cont[[i]] <-
        curl::curl_fetch_memory(tars[i])$content %>%
        rawToChar()
    }

    dl <- lapply(cont, function(x)
      jsonlite::fromJSON(x)$list)
    df <- tibble::as.tibble(do.call(rbind, dl))
    if (tqform) {
      df <-
        df[, c("tradeDt",
               "openPrice",
               "highPrice",
               "lowPrice",
               "closePrice",
               "volume")]
      # todo
      # adjusted close price cal
      df$adjusted <- df$closePrice
      names(df) <-
        c("date", "open", "high", "low", "close", "volume", "adjusted")
      df$date <- as.Date(df$date)

      df <- df[(df$date >= as.Date(from)) & (df$date <= as.Date(to)), ]
      df <- df[order(df$date), ]
    }
    return(df)
  }
