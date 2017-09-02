#' Get Content Title
#'
#' Get naver news Title from link.
#'
#' @param html_obj "xml_document" "xml_node" using read_html function.
#' @param title_node_info Information about node names like tag with class or id. Default is "div.article_info h3" for naver news title.
#' @param title_attr if you want to get attribution text, please write down here.
#' @return Get character title.
#' @export
#' @import xml2
#' @import rvest

getContentTitle<-function(html_obj, title_node_info="div.article_info h3", title_attr=""){
  if(title_attr!=""){title <- html_obj %>% html_nodes(title_node_info) %>% html_attr(title_attr)}else{
    title <- html_obj %>% html_nodes(title_node_info) %>% html_text()}
  Encoding(title) <- "UTF-8"
  return(title)
}
