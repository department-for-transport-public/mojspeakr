#' Adds conditional address tags in govspeak only. Displays as formatted text in govspeak, and as simple text only in other formats.
#' @param text address as a string
#' @export
#' @name add_address
#' @title Include a formatted address in govspeak output
add_address <- function(text){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") == "html"){
    cat(paste("$A", text, "$A", sep = '\n'))
  } else{
    cat(paste(text))}
}
