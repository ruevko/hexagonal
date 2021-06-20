blogdown::stop_server()

for (rmdFile in dir('content/post', '\\.Rmd$', full.names = TRUE, recursive = TRUE)) {

   if (!file.exists(sub('.Rmd', '.html', rmdFile))) {

      message(crayon::yellow(sub('content/post/....', 'No .html for ', rmdFile)))

   }

}

for (htmlFile in dir('content/post', '\\.html$', full.names = TRUE, recursive = TRUE)) {

   htmlWrite = FALSE; htmlLines = readLines(htmlFile)

   REFLine = which(htmlLines == '<div id="refs" class="references">')

   if (length(REFLine) == 1) {

      htmlLines = c(htmlLines[1 : {REFLine - 1}],
                    '<span class="post-meta">Referencias</span><div id="refs" class="references">',
                    htmlLines[ - {1 : REFLine}])

      htmlWrite = TRUE; message(crayon::green(sub('content/post/', 'Fixed REF in ', htmlFile)))

   }

   TOCLine = which(htmlLines == '<div id="TOC">')

   if (length(TOCLine) == 1) {

      htmlLines = c(htmlLines[1 : {TOCLine - 1}],
                    '<div id="TOC"><span class="post-meta">Contenido</span>',
                    htmlLines[ - {1 : TOCLine}])

      htmlWrite = TRUE; message(crayon::blue(sub('content/post/', 'Fixed TOC in ', htmlFile)))

   }

   VOFLine = which(htmlLines == '.sourceCode { overflow: visible; }')

   if (length(VOFLine) == 1) {

      htmlLines = htmlLines[ - VOFLine]

      htmlWrite = TRUE; message(crayon::cyan(sub('content/post/', 'Fixed VOF in ', htmlFile)))

   }

   if(htmlWrite) writeLines(htmlLines, htmlFile) else {

      message(crayon::yellow(sub('content/post/', 'All is OK in ', htmlFile)))

   }

}
