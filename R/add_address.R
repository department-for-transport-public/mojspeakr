#' Adds conditional address tags in govspeak only. Displays as formatted text in govspeak, and as simple text only in other formats.
#' @param text address as a string, with each new line separated with a comma
#' @param format string which identifies the outputs you would like the address tags to appear in. Set to HTML as default.
#' @param unmodified logical value. If true, address formatting will not be changed in any formats other than HTML. If false, address will be formatted to include linebreaks in all outputs.
#' @export
#' @name add_address
#' @title Include a formatted address in govspeak output
add_address <- function(text, format = "html", unmodified = FALSE){
  ##If format of chunk is not set to "asis", return a warning
  if(opts_current$get("results") != "asis"){
    warning("Chunk option must be set to result = 'asis'")
  }

  if(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% format){

    text <- gsub(",", " \n", text)
    cat(paste("$A", text, "$A", sep = '\n'))

  } else if(unmodified == FALSE){

    text <- gsub(",", "  \n", text)
    cat(paste(text))

  } else if(unmodified == TRUE){

    cat(paste(text))

    }

}
