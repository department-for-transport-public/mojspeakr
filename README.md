# mojspeakr
{mojspeakr} is a package designed to convert an Rmarkdown file into a formatted govspeak file suitable for publishing through which can be uploaded to the Whitehall publisher (on gov.uk).

##Usage
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

##Functions
