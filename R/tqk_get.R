#' Get quantitative data from korea
#'
#' @return a [tibble][tibble::tibble-package]
#' @param x Stock x. only Korean type like "005930" is samsong.
#' @param get where to get data. Default is daum.
#' @param from Optional for various time series functions. A character string representing a start date in YYYY-MM-DD format.
#' @param to Optional for various time series functions. A character string representing a end date in YYYY-MM-DD format.
#' @param tqform transform data to tidyquant style.
#' @export
#' @importFrom curl curl_fetch_memory
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as.tibble
#' @importFrom httr add_headers user_agent GET content
#' @importFrom purrr transpose
#' @importFrom tibble as_tibble
#' @importFrom dplyr select_if mutate rename left_join

tqk_get <-
  function(x,
           get = c("daum", "paxnet"),
           from = "1900-01-01",
           to = Sys.Date(),
           tqform = T) {

    . <- tradePrice <- NULL

    stopifnot(get %in% c("daum", "paxnet"))

    if (get[1] == "paxnet") {
      print("close and adjusted are same now.")
      root <-
        "http://paxnet.moneta.co.kr/stock/analysis/pagingListAjax?method=listByDate&abbrSymbol="
      tar <- paste0(root, x, "&currentPageNo=1")

      mpn <- curl::curl_fetch_memory(tar) %>%
        .$content %>%
        rawToChar() %>%
        jsonlite::fromJSON() %>%
        .$analysisSearchVO %>%
        .$lastPageNo

      pn <- 1:mpn

      tars <- paste0(root, x, "&currentPageNo=", pn)
      cont <- list()
      for (i in 1:length(tars)) {
        cont[[i]] <-
          curl::curl_fetch_memory(tars[i])$content %>%
          rawToChar()
        Sys.sleep(0.1)
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
          c("date",
            "open",
            "high",
            "low",
            "close",
            "volume",
            "adjusted")
      }

      df$date <- as.Date(df$date)

    } else if (get[1] == "daum") {
      x <- paste0("A", x)
      root <- "http://finance.daum.net/api/charts/"

      ref <- paste0("http://finance.daum.net/api/quote/", x)
      ad <- httr::add_headers(Referer = ref)
      ua <-
        httr::user_agent("tqk package in r by chanyub.park mrchypark@gmail.com")
      tar <- paste0(root, x, "/days?limit=4999&adjusted=false")

      df <-
        httr::GET(tar, ad, ua) %>%
        httr::content() %>%
        .$data
      if (is.null(df)) {
        return(df)
      }
      df <-
        df %>%
        purrr::transpose() %>%
        tibble::as_tibble() %>%
        dplyr::select_if( ~ !all(is.null(unlist(.x)))) %>%
        purrr::map_dfc(~ unlist(ifelse(purrr::map(.x, is.null),0,.x))) %>%
        dplyr::mutate(date = as.Date(date))

      if (tqform) {
        df <-
          df[, c(
            "date",
            "openingPrice",
            "highPrice",
            "lowPrice",
            "tradePrice",
            "candleAccTradeVolume"
          )]

        tar <- paste0(root, x, "/days?limit=4999&adjusted=true")
        adj <-
          httr::GET(tar, ad, ua) %>%
          httr::content() %>%
          .$data %>%
          purrr::transpose() %>%
          tibble::as_tibble() %>%
          dplyr::select_if( ~ !all(is.null(unlist(.x)))) %>%
          purrr::map_dfc(~ unlist(ifelse(purrr::map(.x, is.null),0,.x))) %>%
          dplyr::select(date, tradePrice) %>%
          dplyr::mutate(date = as.Date(date)) %>%
          dplyr::rename(adjusted = tradePrice)

        df <- df %>% dplyr::left_join(adj, by = "date")

        names(df) <-
          c("date",
            "open",
            "high",
            "low",
            "close",
            "volume",
            "adjusted")
      }
    }

    df <-
      df[(df$date >= as.Date(from)) & (df$date <= as.Date(to)),]
    df <- df[order(df$date),]
    return(df)
  }
