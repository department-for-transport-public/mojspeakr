#' Add images which are not auto-generated during the knitting process
#' to all publishing formats.
#' All images must be of size 960 x 640 pixels to allow upload to the
#' Whitehall publishing system, and must be saved with a filename which
#' starts and ends with sequential numbering.
#' For example, if the image will be the third graphic in the final
#' publication, it can be saved as "03-image-1.png".
#' @param file_name string giving the file name of the image only
#' @param folder string giving the directory the image is stored in,
#' defaults to "graphs".
#' @export
#' @name add_image
#' @title Highlight in bold key words in summary text
add_image <- function(file_name, folder = "graphs") {
  paste0("![](", folder, "/", file_name, ")<!-- -->")
}
