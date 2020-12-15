#' Add a logo to the top of a HTML pre-release to mimic the appearance of gov.uk
#' This should be done for the pre-release only, and not for the final statistics publication
#' @param img string giving the location of the logo as a png file.
#' @export
#' @name add_logo
#' @title Add a logo to the top of a HTML pre-release
add_logo <- function(img){
  conditional_publishing_output(
    output = cat("[<img src='", img, "'  width='120' height='120'>](https://www.gov.uk/government/organisations/ministry-of-justice)", sep = ""),
    publication_type = "html")
}

