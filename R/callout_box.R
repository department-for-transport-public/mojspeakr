#' Adds conditional CTA tags in govspeak only. Displays as text in a box in govspeak, and as simple text only in other formats.
#' @param text string to publish in a callout box
#' @export
#' @name callout_box
#' @title Include a callout box in govspeak output
callout_box <- function(text){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") == "html"){
    cat(paste("$CTA", text, "$CTA", sep = '\n'))
  } else{
    cat(paste(text))}
}
