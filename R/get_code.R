#' Get company code
#'
#' Get code for korea finance market
#'
#' @return tibble(code, name, category)
#' @export
#' @import rvest
#' @import tibble

get_code<-function(){
  tar <- "http://bigdata-trader.com/itemcodehelp.jsp"
  cd <-
    read_html(tar) %>%
    html_nodes("table") %>%
    html_table %>%
    .[[1]]
  cd<-as_tibble(cd)
  names(cd)<-c("code","name","category")
  return(cd)
}
