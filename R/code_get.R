#' Get company code
#'
#' Get code for korea finance market
#'
#' @return a [tibble][tibble::tibble-package]
#' @export
#' @importFrom rvest html_nodes html_table
#' @importFrom httr GET content
#' @importFrom tibble as.tibble

code_get<-function(){
  . <- NULL
  tar <- "http://bigdata-trader.com/itemcodehelp.jsp"
  cd <-
    httr::GET(tar) %>%
    httr::content() %>%
    rvest::html_nodes(css="table") %>%
    rvest::html_table() %>%
    .[[1]] %>%
    tibble::as.tibble()
  names(cd)<-c("code","name","category")
  return(cd)
}
