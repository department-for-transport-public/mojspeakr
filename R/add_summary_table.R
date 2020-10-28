#' Add summary table containing key points of statistical release.
#' Traditionally these consist of key points, images of arrows to indicate direction of change, and detailed description of the key points.
#' This normal structure is outputted in word and pdf formats, while the govspeak format includes only the two text columns.
#' The govspeak format also highlights key words indicating direction of change in the description.
#' @param left vector of key points which will appear in left column
#' @param middle vector of arrow image calls which will appear in middle column
#' @param right vector of descriptions of key points which will appear in right column
#' @param key_words vector of key change words to highlight in right column. A preloaded vector of these key words is already included, but additional words can be added as desired.
#' @export
#' @name add_summary_table
#' @title Produce summary table for key points in conditional format
add_summary_table <- function(left, middle, right, key_words = NULL){

  left <- bold_text(left)

  if (knitr::opts_knit$get("rmarkdown.pandoc.to") %in% c("html", "markdown_strict")){
    right_bolded <- bold_key_words(right, key_words = key_words)
    html_table <- data.frame(left, right_bolded)
    colnames(html_table) <- NULL
    knitr::kable(html_table, format = "markdown")
  } else{
    normal <- data.frame(left, middle, right)
    colnames(normal) <- NULL # Remove column titles
    knitr::kable(normal, format = "markdown")}
}
