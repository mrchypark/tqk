#' Get company code
#'
#' Get code for korea finance market
#'
#' @return tibble(code, name, category)
#' @export
#' @importFrom rvest html_nodes html_table
#' @importFrom xml2 read_html
#' @importFrom tibble as.tibble

code_get<-function(){
  . <- NULL
  tar <- "http://bigdata-trader.com/itemcodehelp.jsp"
  cd <-
    xml2::read_html(tar) %>%
    rvest::html_nodes(css="table") %>%
    rvest::html_table() %>%
    .[[1]] %>%
    tibble::as.tibble()
  names(cd)<-c("code","name","category")
  return(cd)
}
