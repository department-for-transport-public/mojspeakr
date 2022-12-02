#' Adds conditional address tags in govspeak only.
#' Displays as formatted text in govspeak,
#' and as simple text only in other formats.
#' @param text address as a string, with each new line separated with a comma
#' @param format string which identifies the outputs you would like
#' the address tags to appear in. Set to HTML as default.
#' @param unmodified logical value. If true, address formatting will not be
#' changed in any formats other than HTML.
#' If false, address will be formatted to include linebreaks in all outputs.
#' @export
#' @importFrom knitr asis_output
#' @name add_address
#' @title Include a formatted address in govspeak output
add_address <- function(text, format = "html", unmodified = FALSE) {

  if (knitr::opts_knit$get("rmarkdown.pandoc.to") %in% format) {

    text <- gsub(",", " \n", text)
    knitr::asis_output(paste("$A", text, "$A", sep = "\n"))

  } else if (unmodified == FALSE) {

    text <- gsub(",", "  \n", text)
    knitr::asis_output(text)

  } else if (unmodified == TRUE) {

    knitr::asis_output(text)

    }

}
