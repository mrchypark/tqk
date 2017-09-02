#' Get Content Title
#'
#' Get code for korea finance market
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param title_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param title_attr if you want to get attribution text, please write down here.
#' @return Get character title.
#' @export
#' @import rvest

update_code<-function(category = c("ALL"
                                   , "KOSPI"
                                   , "KOSDAQ"
                                   , "ETF"
                                   , "INDEX"
                                   , "KOSPIchart_algscore_cumulative"
                                   )){
  tar <- "http://bigdata-trader.com/itemcodehelp.jsp"
  codeData <-
    read_html(tar) %>%
    html_nodes("table") %>%
    html_table %>%
    .[[1]]
  names(codeData)<-c("code","name","category")
  return(codeData)
}
