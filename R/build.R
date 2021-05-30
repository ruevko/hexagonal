blogdown::stop_server()

for (rmdFile in dir('content/post', '\\.Rmd$', full.names = TRUE, recursive = TRUE)) {

   if (!file.exists(sub('.Rmd', '.html', rmdFile))) {

      message(crayon::yellow(sub('content/post/....', 'No .html for ', rmdFile)))

   }

}

for (htmlFile in dir('content/post', '\\.html$', full.names = TRUE, recursive = TRUE)) {

   htmlLines = readLines(htmlFile)

   TOCLine = which(htmlLines == '<div id="TOC">')

   if (length(TOCLine) == 1) {

      htmlLines = c(htmlLines[1 : {TOCLine - 1}],
                    '<div id="TOC"><h1 style="margin: 8px 0px;">Contenido</h1>',
                    htmlLines[ - {1 : TOCLine}])

      message(crayon::blue(sub('content/post/....', 'Fixed TOC in ', htmlFile)))

   }

   VOFLine = which(htmlLines == '.sourceCode { overflow: visible; }')

   if (length(VOFLine) > 0) {

      htmlLines = htmlLines[ - VOFLine]

      message(crayon::cyan(sub('content/post/....', 'Fixed VOF in ', htmlFile)))

   }

   writeLines(htmlLines, htmlFile)

}
