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
  for (i in 1:length(key_words)) {

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
  ##Stop at this point if there aren't any
  if(length(img_tags) == 0){
    message("No images found")
  } else{
  #Split on the ! symbols
  img_tags <- unlist(strsplit(img_tags, split = "(?<=.)(?=[!])", perl = TRUE))
  ##Drop anything which doesn't then start with ![]
  img_tags <- img_tags[grepl('![]', img_tags, fixed = TRUE)]
  #Clean up trailing < symbols
  img_tags <- gsub("[<]$", "", img_tags)

  ##Make it a table with row line numbers from original text indicated
  data <- data.frame(img_tags = img_tags)

  for (i in 1:nrow(data)){
    data[i, "lines"] <- grep(data[i, "img_tags"], lines, fixed = TRUE)
  }

  ##Order by row number and figure name
  #(will be in order if they're from the same block)
  data <- data[order(data$lines, data$img_tags), ]

  ##Create clean image references and govspeak tags
  data$img_ref <- gsub("\\!\\[\\][(](.*)[)]", "\\1", data$img_tags)
  data$govspeak <- paste0("!!", row.names(data))

  return(data)
  }
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

#Take our image references and number them in a way that
#doesn't look like a drunk mathematician rolling dice
#' @param img_ref table of image references
#' @param img_wd working directory that image paths are listed from.
#' In most cases, this will be the same folder as the md document is stored in
#' @name order_img_ref
#' @keywords internal
#' @title Order image references in a logical way

order_img_ref <- function(img_ref, img_wd){

  ##Take image references and swap out the img_ref so they're all just called
  #image-something in order
  img_ref$img_ref_old <- img_ref$img_ref

  for(i in 1:nrow(img_ref)){
    img_ref[i, "img_ref"] <- gsub("(.*[/]).*([.].*)$",
                                  paste0("\\1", "image", i, "\\2"),
                                  img_ref[i, "img_ref"])

    #Rename our images to match
    #Include warning if it's not found
    if(file.exists(file.path(img_wd, img_ref[i, "img_ref_old"]))){
      file.rename(
        from = file.path(img_wd, img_ref[i, "img_ref_old"]),
        to = file.path(img_wd, img_ref[i, "img_ref"]))

      message(file.path(img_wd, img_ref[i, "img_ref_old"]), " renamed to ",
      file.path(img_wd, img_ref[i, "img_ref"]))
    } else{

      warning(
       file.path(img_wd, img_ref[i, "img_ref_old"]), " not found")
    }
  }

  return(img_ref)

}
