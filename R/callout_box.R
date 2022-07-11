#' Adds conditional CTA tags in govspeak only. Displays as text in a box in govspeak, and as simple text only in other formats.
#' @param text string to publish in a callout box
#' @param format string which identifies the outputs you would like the callout box tags to appear in. Set to HTML as default.
#' @export
#' @name callout_box
#' @title Include a callout box in govspeak output
callout_box <- function(text, format = "html"){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% format){

      knitr::asis_output(paste("$CTA", text, "$CTA", sep = '\n'))

  } else{
    cat(paste(text))}
}
