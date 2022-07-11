#' Adds conditional CTA tags in govspeak only. Displays as text in a box in govspeak, and as simple text only in other formats.
#' @param text string to publish in a callout box
#' @param format string which identifies the outputs you would like the callout box tags to appear in. Set to HTML as default.
#' @export
#' @name callout_box
#' @title Include a callout box in govspeak output
callout_box <- function(text, format = "html"){
  if(knitr::opts_knit$get("rmarkdown.pandoc.to") %in% format){

      knitr::asis_output(paste("$CTA", text, "$CTA", sep = '\n'))

  }else if(knitr::opts_knit$get("rmarkdown.pandoc.to") == "html"){

    #Nice formatting for HTML output if required

    knitr::asis_output(
      paste("<style type='text/css'>
        cta {
          text-align: left;
          background-color: #f3f2f1 ;
          height: 40px;
          padding-top: 20px;
          padding-bottom: 60px;
          padding-left: 30px;
          padding-right: 30px;
          display: block;
          margin-left: auto;
          margin-right: auto;
          width: 100%;

        }
       </style>",
        "<cta>",
        text,
        "</cta>", sep = '\n'))

  }else{

    cat(paste(text))
    }
}
