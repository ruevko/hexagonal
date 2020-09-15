---
title: {{ replace .TranslationBaseName "-" " " | title }}
date: {{ .Date }}

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
    toc: true                 # remove if no content

math: true                    # remove if no equations
link-citations: true          # remove if no citations
bibliography: ../../babel.bib # remove if no citations

thumbnailImage: /octocat.png
summary: Proudly hosted in [GitHub Pages](https://pages.github.com/)
---
