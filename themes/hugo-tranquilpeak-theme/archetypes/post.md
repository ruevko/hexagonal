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
- Translate those tags

editor_options: 
  chunk_output_type: console

output:
   blogdown::html_page:
      highlight: kate
      toc: true

math: true
link-citations: true
bibliography: ../../babel.bib

thumbnailImage: /octocat.png
summary: Proudly hosted in [GitHub](https://github.com/)
---
