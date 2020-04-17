#' Convert markdown file to Whitehall Publisher (GOV.UK) govspeak markdown format
#' @param path string; filename (including path) to *.md file for conversion
#' @param images_folder string; folder containing images for *.md file. Defaults
#'   to "graphs"
#' @param remove_blocks bool; decision to remove block elements from *.md file.
#'   This includes code blocks and warnings
#' @param sub_pattern bool or vector; decision to increase hashed headers by one level in *.md file.
#'   TRUE will substitute all, FALSE will substitute none, while a vector of the desired substitution levels allows individual headings to be modified as required.
#'   e.g. "#" will modify only first level headers.
#' @param page_break string; chooses what page breaks are converted to on Whitehall.
#' If "line", page breaks are replaced with a horizontal rule. If "none" they are replaced with a line break.
#' If "unchanged" they are not removed.
#' @export
#' @name convert_rmd
#' @title Convert standard markdown file to govspeak
convert_rmd <- function(path,
                        images_folder = "graphs",
                        remove_blocks=FALSE,
                        sub_pattern = TRUE,
                        page_break = "line"
) {

  ##Check listed directory exists
  if (dir.exists(images_folder)==F) {
    stop(paste0("The specified images folder (", images_folder, ") does not exist. Please use the images_folder argument to specify the correct location"))
  }

  ##Check that files end with numeric values
  files <- list.files(images_folder)
  files <- sub("\\..*", "", files)
  file_check <- suppressWarnings(mean(!is.na(as.numeric(stringi::stri_sub(files, -1)))))
  if(file_check != 1){
    stop(paste("Not all filenames in folder", images_folder, "start and end with numeric values. If you have uploaded images not produced in this Markdown file, please make sure they are named appropriately."))

  }

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

  #Remove long strings of hashes/page break indicators and move all headers down one level
  if(page_break == "line"){
    govspeak_file <- gsub("#####|##### <!-- Page break -->", "-----", govspeak_file)
  }else if(page_break == "none"){
    govspeak_file <- gsub("#####|##### <!-- Page break -->", "\n", govspeak_file)
  }else if(page_break == "unchanged"){
    govspeak_file <- govspeak_file
  }
  govspeak_file <- hash_sub(govspeak_file, sub_type = sub_pattern)

  write(govspeak_file, gsub("\\.md", "_converted\\.md", path))
  if (remove_blocks) {
    govspeak_file <- remove_rmd_blocks(govspeak_file)
  }
}
