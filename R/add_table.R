#' Add a table in Rmarkdown suitable for publication in govspeak and in word/PDF
#' @param data dataframe; dataframe of any size to be displayed as a table
#' @export
#' @name add_table
#' @example add_table(iris)
#' @title Format data in a table suitable for publication
add_table <- function(data) {
  knitr::kable(data, format = "markdown")
}
