# mojspeakr
{mojspeakr} is a package designed to convert an Rmarkdown file into a formatted govspeak file suitable for publishing through which can be uploaded to the Whitehall publisher on ([GOV.UK](https://www.gov.uk)). It builds on the ([govspeakr](https://github.com/best-practice-and-impact/govspeakr)) package and contains additional conversions which address specific design elements in MoJ statistical releases. It is also designed to make RAP output in both govspeak and word/PDF format easy from one RMarkdown file. This is particularly useful when you want to publish in both accessible and traditional PDF formats, or when you want to carry out QA of the govspeak publication.

## Usage
{mojspeakr} is designed to be used with an RMarkdown file which outputs a HTML file and another format (e.g. PDF or word). 

The conversion acts on a markdown (\*.md) file only, so R markdown (\*.Rmd) should first be converted/knitted to \*.md. This can be achieved through:

```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
---
```

Dual output of govspeak and word/PDF can be achieved as follows:

```
---
title: "My Rmarkdown File"
output: 
  html_document:
    keep_md: true
  word_document:
    #any other parameters relevant to the word document here
---
```

## Installation
This package is available on github. To install, run the following code:

```
library(devtools)
install_github("moj-analytical-services/mojspeakr")
```

## Functions

**convert_rmd()**: Following rendering of the output, this function modifies formatting of the .md file to produce a govspeak output which can be read by Whitehall Publishing:

* Image tags are converted from standard markdown to govspeak i.e.
```
Figure 1
![](images/image1.png)<!-- -->!

Figure 1
!!1
```

* Page breaks are replaced with horizontal rulings

* YAML header is removed

* As GOV.UK cannot accept first-level headers (single #), all hashed headers are increased by one level i.e.
``` # Title ``` becomes ```## Title```

**add_image()**: Allows simple addition of figures which are not generated within the Rmarkdown document. These must adhere to the Whitehall publishing size of 960 by 720 pixels, and must be saved with a number at the start and end of the filename. 

**add_table()**: Formatting of a table to display in both govspeak and word formats, and allows for text to go over multiple lines.

**conditional_publishing_output()**: Aims to make publishing two formats from one RMarkdown document simple. This wrapper allows any output to be conditional and only appear in one of the specified formats e.g. to output table_one in the HTML output only you can use:

```
conditional_publishing_output("html", table_one)
```
**add_summary_table()**: MoJ stats summary tables consist of three columns, one of which contains directional arrow images which are not compatible with publication through the Whitehall platform. Instead a 2-column table which omits these images and highlights key directional phrases and words is used instead. This function takes three vectors and conditionally produces either the two- or three- column table depending on the output type.

**callout_box()**: Some publications use a callout box to add emphasis to text in an online publication via $CTA tags. This function automatically adds these $CTA tags to text in the govspeakr output only. Any Rmarkdown code chunk using this function must include 
```
{r "results='asis'"}
```
in the chunk options.

