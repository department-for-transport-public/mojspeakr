#' Extracts image references from the original markdown output into Whitehall format
#' @param lines raw contents of md file (from readLines)
#' @name generate_image_references
#' @keywords internal
#' @title Generate govdown image references
generate_image_references <- function(lines) {

  #Split any lines on <-- --> to get one image per line chaps
  lines <- unlist(strsplit(lines, "<!-- -->"))

  ##Sub out markdown format for Whitehall format
  lines <- gsub("\\!\\[\\]\\(.*\\/(.*)\\)", "[Image:\\1]", lines)

  return(lines)
}


#' Convert markdown callout sytax to govspeak
#' @param md_file string; markdown file text
#' @name convert_callouts
#' @keywords internal
#' @title Convert markdown callout syntax to govspeak
#'
convert_callouts <- function(md_file) {
  # Lazy match on lines starting with ">", which are then flanked with "^"
  # Currently only catches single line callouts

  gsub("(\\n)>[ ]*(.*?\\n)",
       "\\1^\\2",
       md_file)
}


#' Replace R markdown header with title only
#' @param md_file string; markdown file text
#' @name remove_header
#' @keywords internal
#' @title Replace R markdown header with ## title
remove_header <- function(md_file) {

  # Lazy match on header to extract title
  # Remove substitution if titles must be entered manually
  gsub("---\\n\\s*.*?\\s*output\\s*.*?\\s*---\\n",
       "",
       md_file)

}


#' Remove R markdown multiline block elements
#' (package warnings, but also multiline code blocks)
#' @param md_file string; markdown file text
#' @name remove_rmd_blocks
#' @keywords internal
#' @title Remove R markdown multiline block elements
#' (package warning and code block)
#'
remove_rmd_blocks <- function(md_file) {

  # Lazy match on warnings and code blocks
  gsub("```\\n.*?```\\n\\n", "", md_file)

}


#' Substitute hashed Rmarkdown headers with the next level down down
#' e.g. # to ##
#' @param x string object to substitute one # value for another
#' @param sub_type logical or vector, TRUE will substitute all heading levels,
#' FALSE will substitute none, alternatively a vector will allow you
#' to select specific levels of header to substitute.
#' @name hash_sub
#' @keywords internal
#' @title Increase Rmarkdown headers by one level
#'
hash_sub <- function(x, sub_type) {

  if (TRUE %in% sub_type) {

    #Substitute any number of hashes for that number plus 1
    gsub("(#{1,})", "\\1#", x)

  } else if (FALSE %in% sub_type) {
    #Sub nothing
    x
  } else {
    ##Substitute the values passed to the argument as a vector
    #Collapse that funky little vector into a regex string
    sub_type <- paste0("(\\b|[^#])(",
                       paste(sub_type, collapse = "|"), ")([^#])")

    #Regex; swap any of the listed patterns for that plus one #.
    #God 2022 Fran is so much better at this that 2019 Fran
    x <- gsub(sub_type, "\\1#\\2\\3", x)

    return(x)
  }
}
