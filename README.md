# mojspeakr

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![check-release](https://github.com/moj-analytical-services/mojspeakr/actions/workflows/check-release.yaml/badge.svg)](https://github.com/moj-analytical-services/mojspeakr/actions/workflows/check-release.yaml)
<!-- badges: end -->

{mojspeakr} is a package designed to convert an Rmarkdown file into a formatted govspeak file suitable for publishing through which can be uploaded to the Whitehall publisher on ([GOV.UK](https://www.gov.uk)). It was inspired by the ([govspeakr](https://github.com/best-practice-and-impact/govspeakr)) package to  address specific challenges in MoJ statistical releases. In particular, it allows easy RAP output in both govspeak and word/PDF format from one RMarkdown file. This is particularly useful when you want to publish in both accessible and traditional PDF formats, or when you want to carry out QA of the govspeak publication.

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

### convert_rmd() 
Following rendering of the output, this function modifies formatting of the .md file to produce a govspeak output which can be read by Whitehall Publishing:

* Image tags are converted from standard markdown to govspeak i.e.
```
Figure 1
![](images/image1.png)<!-- -->!

Figure 1
!!1
```

* Page breaks are replaced. This feature can be controlled using the "page_break" argument. ```page_break = "line"``` replaces them with a horizontal ruling, while ```page_break = "none"``` just moves the subsequent text onto a new line, and ```page_break = "unchanged"``` makes no replacement.

* YAML header is removed

* As GOV.UK cannot accept first-level headers (single #), all hashed headers are increased by one level i.e.
``` # Title ``` becomes ```## Title```
This functionality can be controlled using the sub_pattern argument. Setting it to TRUE increases all headers by one level. FALSE results in no changes to the headers as written. Passing the argument a vector allows selective changing of specific headers, e.g. ```sub_pattern = c("#", "##")``` would change only first and second level headers.

### add_image() 
Allows simple addition of figures which are not generated within the Rmarkdown document. These must adhere to the Whitehall publishing size of 960 by 640 pixels, and must be saved with a sequential number at the start and end of the filename. For example, an image which will become the third image in the completed document could be called ```03-image-1.png```.

### add_table() 
Formats a dataframe of data into a table. This will display correctly in both govspeak and word formats, and allows for text to go over multiple lines.

### conditional_publishing_output()
Aims to make publishing two formats from one RMarkdown document simple. This wrapper allows any output to be conditional and only appear in one of the specified formats e.g. to output table_one in the HTML output only you can use:

```
conditional_publishing_output("html", table_one)
```
This output will not appear at all in any non-HTML outputs such as word or pdf.

The full list of options that can be used in the first argument are:

* **"html"** for HTML/govspeak output
* **"docx"** for Word output
* **"latex"** for PDF output
* **"markdown_strict"** for markdown output
* **"pptx"** for powerpoint presentation
* **"beamer"** for beamer presentation
* **"odt"** for odt output

### add_summary_table() 
MoJ stats summary tables consist of three columns, one of which contains directional arrow images which are not compatible with publication through the Whitehall platform. Instead a 2-column table which omits these images and highlights key directional phrases and words is used. This function takes three vectors and conditionally produces either the two- or three- column table depending on the output type. A two-column table is produced in the govspeak output, and a three-column table is produced in all other output types.

### callout_box() 
Some publications use a callout box to add emphasis to text in an online publication via $CTA tags. This function automatically adds these $CTA tags to text in the govspeakr output only. Any Rmarkdown code chunk using this function must include 
```
{r results='asis'}
```
in the chunk options.

### add_email() 
Email addresses should appear as links in the govspeakr output only, and as plain text in all other formats. This function conditionally adds "<>" bracketing email addresses in the govspeakr output only. It can be used in inline code in Rmarkdown e.g. 
```
Email: `r add_email(test@email.com)`
```

### add_address()
Postal addresses should appear as formatted text in govspeakr output only, and as plain text in all other formats. This function conditionally adds "$A" bracketing addresses in the govspeakr output only, and as a default also ensures that each part of the address is displayed on a new line in both outputs. 

If you would like addresses to appear unformatted in all other formats, please add a call of "unmodified = T" to this function. 

It accepts addresses as a single string, with each line separated by a comma e.g.
```
add_address("123 Fake Street, Leeds, LS1 2DA")
```
Any Rmarkdown code chunk using this function must include 
```
{r results='asis'}
```
in the chunk options.

## Pre-release functions
The package also contains several functions which are relevant to HTML pre-releases only, to mimic the appearance of gov.uk. It is not necessary to use these headers on gov.uk.

### add_logo()
Adds a logo (e.g. MoJ logo) to the top of the HTML release, as per gov.uk. 

Any Rmarkdown code chunk using this function must include 
```
{r results='asis'}
```

### add_blue_header()
Includes details of the statistical publication in a blue header, mimicking the appearance of gov.uk. 

Any Rmarkdown code chunk using this function must include 
```
{r results='asis'}
```
