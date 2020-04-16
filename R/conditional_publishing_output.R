#' Conditional display of specified objects when RMarkdown document is knitted.
#' Expression will display the object only in the specified Rmarkdown output type.
#' @param publication_type string describing type of RMarkdown output you would like the object to appear in. Options include "html" for html_document, "docx" for word_document, and "pdf" for pdf_document.
#' @param output object to display in the document; can be a table, text, graph, or image.
#' @export
#' @name conditional_publishing_output
#' @title Conditional display of object depending on Rmarkdown publication type.
conditional_publishing_output <- function(publication_type, output){
  if (opts_knit$get("rmarkdown.pandoc.to") == publication_type){output}
}
