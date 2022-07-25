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
      sub_words <- paste0(" **", key_words[i], "** ")
      search_words <- paste0(" ", key_words[i], " ")
      bracket_sub_words <- paste0("\\(**", key_words[i], "** ")
      bracket_search_words <- paste0("\\(", key_words[i], " ")

      temp <- gsub(search_words,
                   sub_words,
                   temp,
                   ignore.case = TRUE)

      temp <- gsub(bracket_search_words,
                   bracket_sub_words,
                   temp,
                   ignore.case = TRUE)
    }
    return(temp)
}



#' Converts image file names to a dataframe, with a field containing the
#' original image name and corresponding govdown reference
#' @param img_filenames character vector of files to be referenced in govdown
#' format (!!n). The filename must start and end with a number and have text in
#' between (eg, "1-abcd-1.png")
#' @name generate_image_references
#' @keywords internal
#' @title Generate govdown image references
generate_image_references <- function(img_filenames) {

  # Strip ext - not image file specific
  image_references <- data.frame(image_file =
                                   tools::file_path_sans_ext(img_filenames))

  # Capture chunk number and image position within chunk
  if (!all(grepl("^[0-9]", image_references$image_file))) {
    stop("image chunk names must start with a number,
         which should correspond to their order in the .Rmd file")
  }

  image_references$pre_dec <- gsub("([0-9]+).*$",
                                   "\\1",
                                   image_references$image_reference)
  image_references$post_dec <- gsub(".*([0-9]+)$",
                                    "\\1",
                                    image_references$image_reference)

  # Convert to decimal for ranking
  image_references$combined <- as.numeric(paste0(image_references$pre_dec,
                                                 ".",
                                                 image_references$post_dec))

  image_references$image_reference <- paste0("!!",
                                             rank(image_references$combined))

  # Keep mapping of image files to govspeak references
  image_references <- image_references[, c("image_file", "image_reference")]
  return(image_references)
}


#' Convert markdown image references to govspeak format (!!n)
#' @param image_references dataframe of image file names and associated govdown
#'   reference.
#' @param md_file string with markdown file text
#' @param images_folder string; folder containing images for *.md file
#' @name convert_image_references
#' @keywords internal
#' @title Convert markdown image references to govdown
convert_image_references <- function(image_references, md_file, images_folder) {
  govspeak_image_reference_file <- as.character(md_file)
  for (i in seq_along(image_references$image_file)) {
    file_name <- image_references$image_file[i]

    # Construct markdown reference to image file
    md_image_format <- paste0("!\\[\\]\\(",
                              images_folder,
                              "/",
                              file_name,
                              "\\)<!-- -->")

    govspeak_reference <- paste0(as.character(
      image_references$image_reference[i]),
                                 "\n")

    # Replace markdown image reference with govspeak reference
    govspeak_image_reference_file <- gsub(md_image_format,
                                          govspeak_reference,
                                          govspeak_image_reference_file)
  }
  return(govspeak_image_reference_file)
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

#' Bold all text in a vector
#' @param data vector containing strings of interest
#' @name bold_text
#' @keywords internal
#' @title Add RMarkdown annotation to bold all text in a vector
bold_text <- function(data) {

  bolded <- NULL
  for (i in seq_along(data)) {

    a <- paste0("**", data[i], "**")
    bolded <- c(bolded, a)
  }

  return(bolded)
}

#' Substitute hashed Rmarkdown headers with the next level down down
#' e.g. # to ##
#' @param data object to substitute
#' @param sub_type logical or vector, TRUE will substitute all heading levels,
#' FALSE will substitute none, alternatively a vector will allow you
#' to select specific levels of vector.
#' @name hash_sub
#' @keywords internal
#' @title Increase Rmarkdown headers by one level
#'
hash_sub <- function(data, sub_type) {

  if (TRUE %in% sub_type) {

    gsub("# ", "## ", data)

    } else if (FALSE %in% sub_type) {
      data
      } else {
        sub_type <- sub_type[(order(stringi::stri_length(sub_type),
                                    decreasing = TRUE))]
        data_final <- data
        for (i in seq_along(sub_type)) {

          sub_type1 <- paste0("\n", sub_type[i], " ")
          replacement <- gsub("# ", "## ", sub_type1)
          data_final <- gsub(sub_type1, replacement, data_final)
          }
        return(data_final)
      }
  }
