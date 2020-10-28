#' Adds linked email address in govspeak only. Displays as a link in govspeak, and as simple text only in other formats.
#' @param text email address as string
#' @export
#' @name add_email
#' @title Include an email address as a link
add_email <- function(text){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% c("html", "markdown_strict")){
    paste0("<", text, ">")
  } else{
    paste(text)}
}
