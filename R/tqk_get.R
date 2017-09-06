#' Get quantitative data from korea in `tibble` format
#'
#' @param code Stock code.
#' @param from Optional for various time series functions. A character string representing a start date in YYYY-MM-DD format.
#' @param to Optional for various time series functions. A character string representing a end date in YYYY-MM-DD format.
#' @param source not use now.
#' @export
#' @import curl
#' @importFrom jsonlite fromJSON
#' @importFrom magrittr %>%
#' @importFrom tibble as.tibble

tqk_get<-function(code, from, to=Sys.Date(), source=c("p","d","n")){
  # todo
  # now just use p source only
  root<-"http://paxnet.moneta.co.kr/stock/analysis/pagingListAjax?method=listByDate&abbrSymbol="
  tar<-paste0(root,code,"&currentPageNo=1")

  mpn<-curl_fetch_memory(tar) %>%
    .$content %>%
    rawToChar() %>%
    jsonlite::fromJSON() %>%
    .$analysisSearchVO %>%
    .$lastPageNo

  pn<-1:mpn

  success <- function(res){
    dat <<- c(dat, list(res$content))
  }

  pool <- new_pool(host_con = 20)
  dat <- list()
  tars<-paste0(root,code,"&currentPageNo=",pn)

  sapply(tars, function(x) curl_fetch_multi(x,success))
  res <- multi_run()
  dl<-lapply(dat, function(x) jsonlite::fromJSON(rawToChar(x))$list)
  df<-as.tibble(do.call(rbind,dl))
  return(df)
}


