#' Set parameters necessary for publishing on Whitehall.
#' Includes setting specific figure height and width and
#' suppressing warning messages
#' @export
#' @name knitr_opts_set
#' @param fig.path folder to save generated images to. Defaults to "graphs"
#' @title Set knitr parameters to allow publishing on Whitehall
knitr_opts_set <- function(fig.path = "graphs/") {

  knitr::opts_chunk$set(
  #Prevent creation of warning or other message blocks - should be used only
  # when publishing output, so that you remain aware of warnings
    echo = FALSE,
    cache = FALSE,
    warning = FALSE,
    message = FALSE,
  # Image size rules for GOV.uk
    fig.width = 960 / 72,
    fig.height = 640 / 72,
    dpi = 72,
  # The default path for mojspeakr::convert_rmd() to check for images
  #is ./graphs
    fig.path = fig.path
  )
}
