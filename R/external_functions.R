#' Add a table suitable for publication in govspeak and in word/PDF
#' @param data dataframe you want to display as a table
#' @export
#' @name add_table
#' @title Format data in a table suitable for publication
add_table <- function(data) {
  knitr::kable(data, format = "markdown")
}

#' Conditional display of specified outputs when RMarkdown document is knitted
#' @param publication_type string describing type of RMarkdown output you would like the output to appear in
#' @param output object you want to output into document; can be a table, text, graph, or image.
#' @export
#' @name conditional_publishing_output
#' @title Highlight in bold key words in summary text
conditional_publishing_output <- function(publication_type, output){
  if (opts_knit$get("rmarkdown.pandoc.to") == publication_type){output}
}

#' Add external images to both HTML and other formats, these must be of 960 x 640 pixels to allow upload
#' @param file_name string giving the file name of the image only
#' @param folder string giving the directory the image is stored in, defaults to "graphs".
#' @export
#' @name add_image
#' @title Highlight in bold key words in summary text
add_image <- function(file_name, folder = "graphs"){
  paste0("![](", folder, "/", file_name, ")<!-- -->")
}


#' Compares summary points to vector of words indicating change, and highlights relevant words in bold.
#' @param data character vector of summary points
#' @param key_words character vector of additional words you would like to highlight in bold (defaults to NULL)
#' @export
#' @name bold_key_words
#' @title Highlight in bold key words in summary text
bold_key_words <- function(data, key_words = NULL) {
  ##Concatenate chosen key words with pre-existing list
  key_words <- c(key_words, "decreasing", "increasing", "no change", "decreased", "increased", "down", "up", "stable")
  temp <- data
  for(i in 1:length(key_words)){
    sub_words <- paste0("**", key_words[i], "**")
    temp <- gsub(key_words[i], sub_words, temp, ignore.case = T)}
  return(temp)
}

#' Add summary table. Contains arrows indicating direction in word and PDF format, contains only text with key words highlighted in govspeak format.
#' @param left vector of left column key points
#' @param middle vector of arrow image calls
#' @param right vector of right column descriptions of key points
#' @export
#' @name add_summary_table
#' @title Produce summary table for key points in conditional format
add_summary_table <- function(left, middle, right){
bold_text <- function(data){
  bolded <- NULL
  for(i in 1:length(data))
  {
    a <- paste0("**", data[i], "**")
    bolded <- c(bolded, a)
  }
  return(bolded)
}

left <- bold_text(left)

if (opts_knit$get("rmarkdown.pandoc.to") == "html"){
  right_bolded <- bold_key_words(right)
  html_table <- data.frame(left, right_bolded)
  colnames(html_table) <- NULL
  knitr::kable(html_table, format = "markdown")
} else{
  normal <- data.frame(left, middle, right)
  colnames(normal) <- NULL # Remove column titles
  knitr::kable(normal, format = "markdown")}
}

#' Convert markdown file to Whitehall Publisher (GOV.UK) govspeak markdown format
#' @param path string; filename (including path) to *.md file for conversion
#' @param images_folder string; folder containing images for *.md file. Defaults
#'   to "graphs"
#' @param remove_blocks bool; decision to remove block elements from *.md file.
#'   This includes code blocks and warnings
#' @export
#' @name convert_rmd
#' @title Convert standard markdown file to govspeak
convert_rmd <- function(path,
                        images_folder = "graphs",
                        remove_blocks=FALSE
) {
  md_file <- paste(readLines(path), collapse = "\n")

  img_files <- list.files(paste0(dirname(path),
                                 "/",
                                 images_folder))

  image_references <- generate_image_references(img_files)
  govspeak_file <- convert_image_references(image_references,
                                            md_file,
                                            images_folder)

  govspeak_file <- remove_header(govspeak_file)

  govspeak_file <- convert_callouts(govspeak_file)

  ##Remove long strings of hashes and move all headers down one level
  govspeak_file <- gsub("#####", "-----", govspeak_file)
  govspeak_file <- gsub('#(?=[A-Z])', '\\1# ', govspeak_file, perl=T)
  govspeak_file <- gsub('# (?=[A-Z])', '\\1## ', govspeak_file, perl=T)

  if (remove_blocks) {
    govspeak_file <- remove_rmd_blocks(govspeak_file)
  }

  write(govspeak_file, gsub("\\.md", "_converted\\.md", path))
}

