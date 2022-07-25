#' Adds linked email address in govspeak only. Displays as a link in govspeak,
#' and as simple text only in other formats.
#' @param text email address as string
#' @param format string which identifies the outputs you would like the email
#' tags to appear in. Set to HTML as default.
#' @export
#' @name add_email
#' @title Include an email address as a link
add_email <- function(text, format = "html") {
  if (knitr::opts_knit$get("rmarkdown.pandoc.to") %in% format) {
    paste0("<", text, ">")
  } else {
    paste(text)
    }
}
