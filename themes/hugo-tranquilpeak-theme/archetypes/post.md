---
title: {{ replace .TranslationBaseName "-" " " | title }}
date: {{ .Date }}
source: (copy slug).Rmd

categories:
  - category
  - subcategory

tags:
  - tag1
  - tag2

keywords:
  - copy
  - tags

editor_options:
  chunk_output_type: console

output:
  blogdown::html_page:
    highlight: kate
    toc: true                 (in case o titles)

math: true                    (in case of latex)
link-citations: true          (in case of cites)
bibliography: ../../babel.bib (in case of cites)

thumbnailImage: /octocat.png  (or cover instead)
summary: Proudly hosted in [GitHub Pages](https://pages.github.com/)
---
