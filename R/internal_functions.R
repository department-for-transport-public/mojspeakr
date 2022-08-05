#' Compares summary points to vector of words indicating change,
#'  and highlights relevant words in bold.
#' @param data character vector of summary points
#' @param key_words character vector of additional words you would like
#' to highlight in bold (defaults to NULL)
#' @param key_words_remove character vector of standard key words you would NOT
#' like to highlight in bold (defaults to NULL)
#' @name bold_key_words
#' @title Highlight in bold key words in summary text
bold_key_words <- function(data, key_words = NULL, key_words_remove = NULL) {

  ##Concatenate chosen key words with pre-existing list
  key_words <- c(key_words, "decreasing", "decreased", "down", "lower", "fall",
                 "decrease", "fell", "increasing", "increased", "up", "risen",
                 "increase", "rose", "stable", "no change")

  #If key words to remove is not NULL, remove listed words from key_words
  if (!is.null(key_words_remove)) {
    key_words <-  key_words[!(key_words %in% key_words_remove)]
  }

  temp <- data
  for (i in seq_along(key_words)) {

    temp <- gsub(paste0("\\b", key_words[i], "\\b"),
                 paste0("**", key_words[i], "**"),
                 temp,
                 ignore.case = TRUE)

  }
  return(temp)
}



#' Extracts image references from the original markdown output
#' creates a lookup between filename and new govdown reference number
#' @param lines raw contents of md file (from readLines)
#' @name generate_image_references
#' @keywords internal
#' @title Generate govdown image references
generate_image_references <- function(lines) {

  ##Find the image tags (one per line chaps)
  img_tags <- lines[grep("\\!\\[\\]\\(*.", lines)]
  ##Drop arrows to allow us to split on !
  img_tags <- gsub("<!-- -->", "", img_tags, fixed = TRUE)
  #Now we split them on the ! baybeeee
  img_tags <- unlist(strsplit(img_tags, split = "(?<=.)(?=[!])", perl = TRUE))

  ##Make it a table with row line numbers from original text indicated
  data <- data.frame(img_tags = img_tags)

  for (i in seq_len(data)){
    data[i, "lines"] <- grep(data[i, "img_tags"], lines, fixed = TRUE)
  }

  ##Order by row number and figure name
  #(will be in order if they're from the same block)
  data[order(data$lines, data$img_tags), ]

  ##Create clean image references and govspeak tags
  data$img_ref <- gsub("\\!\\[\\][(](.*)[)]", "\\1", data$img_tags)
  data$govspeak <- paste0("!!", row.names(data))

  return(data)

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
