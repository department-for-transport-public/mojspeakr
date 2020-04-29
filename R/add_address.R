#' Adds conditional address tags in govspeak only. Displays as formatted text in govspeak, and as simple text only in other formats.
#' @param text address as a string, with each new line separated with a comma
#' @export
#' @name add_address
#' @title Include a formatted address in govspeak output
add_address <- function(text){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") == "html"){
    text <- gsub(",", " \n", text)
    cat(paste("$A", text, "$A", sep = '\n'))
  } else{
    text <- gsub(",", "  \n", text)
    cat(paste(text))}
}
