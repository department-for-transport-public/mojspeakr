#' Add a blue header bar to the top of a HTML pre-release
#' containing the stats release details to mimic the appearance of gov.uk
#' This should be done for the pre-release only,
#' and not for the final statistics publication
#' @param header_text a string, containing the title of the pre-release to
#' include in the header text
#' @param stats_status a string, designating the statistics status of the
#' pre-release. Defaults to "National Statistics", but can be Official or
#' Experimental statistics
#' @param pre_release_note a string, containing  a pre-release note that will
#' appear underneath the title in the header text. Defaults to "Pre-release".
#' @export
#' @name add_blue_header
#' @title Add the blue header bar at the top of a HTML pre-release

add_blue_header <- function(header_text,
                            stats_status = "National Statistics",
                            pre_release_note = "Pre-release") {

  ##If format of chunk is not set to "asis", return a warning
  if (knitr::opts_current$get("results") != "asis") {
    warning("Chunk option must be set to result = 'asis'")
  }

  conditional_publishing_output(output =
  cat("<br>
    <style>
    div.blue { background-color:#1D70B8; border-radius: 5px; padding: 20px;}
    </style>
    <div class = 'blue'>
    <h2>
    <span style='color: white; font-family: Arial; font-weight: normal;'>",
    stats_status, "</span>
    </h2>
    <h1>
    <span style='color: white; font-family: Arial;
    font-size: 50px; font-weight: bold;'>",
    header_text, "</span>
    </h1>",
    "<h3>
    <span style='color: white; font-family: Arial; font-weight: bold;'>",
    pre_release_note, "</span>
    </h3>
    </div>
    <br>
    <br>"),
  publication_type = "html")
}
