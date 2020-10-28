#' Adds conditional address tags in govspeak only. Displays as formatted text in govspeak, and as simple text only in other formats.
#' @param text address as a string, with each new line separated with a comma
#' @param unmodified logical value. If true, address formatting will not be changed in any formats other than HTML. If false, address will be formatted to include linebreaks in all outputs.
#' @export
#' @name add_address
#' @title Include a formatted address in govspeak output
add_address <- function(text, unmodified = F){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% c("html", "markdown_strict")){
    text <- gsub(",", " \n", text)
    cat(paste("$A", text, "$A", sep = '\n'))
  } else if(unmodified == F){
    text <- gsub(",", "  \n", text)
    cat(paste(text))
  } else if(unmodified == T){
    cat(paste(text))
  }

}
