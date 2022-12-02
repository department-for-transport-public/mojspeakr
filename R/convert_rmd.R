#' Convert markdown file to Whitehall Publisher (GOV.UK) govspeak markdown
#' format
#' @param path string; filename (including path) to *.md file for conversion
#' @param remove_blocks bool; decision to remove block elements from *.md file.
#'   This includes code blocks and warnings
#' @param sub_pattern bool or vector; decision to increase hashed headers by
#' one level in *.md file.
#'   TRUE will substitute all, FALSE will substitute none, while a vector of
#'   the desired substitution levels allows individual headings to be modified
#'   as required.
#'   e.g. "#" will modify only first level headers.
#' @param page_break string; chooses what page breaks are converted to on
#' Whitehall.
#' If "line", page breaks are replaced with a horizontal rule. If "none"
#' they are replaced with a line break.
#' If "unchanged" they are not removed.
#' @param img_wd path to working directory where images folder is stored.
#' In normal usage, this will be the same folder as your markdown file is saved
#' in. This can be passed as an absolute or relative path. Providing a path
#' will convert your image names into a standardised form, default is NULL
#' which does not convert image names.
#' @export
#' @importFrom utils write.csv
#' @name convert_rmd
#' @title Convert standard markdown file to govspeak
convert_rmd <- function(path,
                        remove_blocks = FALSE,
                        sub_pattern = TRUE,
                        page_break = "line",
                        img_wd = NULL) {


  #Read in the raw lines from the md
  md_file <- readLines(path)

  #Get a nice table of image references
  img_ref <- generate_image_references(md_file)

  ##Check there are actually some image references
  if(!is.null(img_ref)){
    #Lets do a little gsub
    for (i in 1:nrow(img_ref)) {
      md_file <- gsub(paste0(img_ref[i, "img_tags"], "<!-- -->"),
                      paste0(img_ref[i, "govspeak"], "\n"),
                      md_file,
                      fixed = TRUE)
    }
  }

  ##Turn md file into plain text
  govspeak_file <- paste(md_file, collapse = "\n")


  govspeak_file <- remove_header(govspeak_file)

  govspeak_file <- convert_callouts(govspeak_file)

  #Remove long strings of hashes/page break indicators
  #and move all headers down one level
  if (page_break == "line") {
    govspeak_file <- gsub("#####|##### <!-- Page break -->",
                          "-----",
                          govspeak_file)
  }else if (page_break == "none") {
    govspeak_file <- gsub("#####|##### <!-- Page break -->",
                          "\n",
                          govspeak_file)
  }else if (page_break == "unchanged") {
    govspeak_file <- govspeak_file
  }

  ##Substitute hashes according to pattern
  govspeak_file <- hash_sub(govspeak_file, sub_type = sub_pattern)

  ##Remove YAML block if requested
  if (remove_blocks) {
    govspeak_file <- remove_rmd_blocks(govspeak_file)
  }

  ##Write output as converted file
  write(govspeak_file, gsub("\\.md", "_converted\\.md", path))

  if(file.exists(gsub("\\.md", "_converted\\.md", path))){
    message("File converted successfully")
  }

  ##If img_wd isn't set to NULL, convert our image tags
  if(!is.null(img_wd)){
    img_ref <- order_img_ref(img_ref = img_ref,
                             img_wd = img_wd)
  }
  if(!is.null(img_ref)){
  ##Write out lil csv of the image path to govspeak lookup
  write.csv(img_ref[, c("img_ref", "govspeak")],
            file = paste0(gsub("(.*[/])*.", "\\1", path), "img_lookup.csv"),
            row.names = FALSE)
  }

}
