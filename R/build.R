blogdown::stop_server()

for (rmdFile in dir('content/post', '\\.Rmd$', full.names = TRUE, recursive = TRUE)) {
   if (!file.exists(sub('.Rmd', '.html', rmdFile))) message(sub('content/post/', 'No .html for ', rmdFile))
}

MET = '<span class="post-meta">X</span>'
REF = '<div id="refs" class="references csl-bib-body hanging-indent">'
TOC = '<div id="TOC">'

for (htmlFile in dir('content/post', '\\.html$', full.names = TRUE, recursive = TRUE)) {
   htmlWrite = FALSE; htmlLines = readLines(htmlFile); REFLine = which(htmlLines == REF)

   if (length(REFLine) == 1) {

      htmlLines = c(htmlLines[1 : {REFLine - 1}], paste0(sub('X','Referencias',MET), REF), htmlLines[ - {1 : REFLine}])

      htmlWrite = TRUE; message(crayon::green(sub('content/post/', 'Fixed REF in ', htmlFile)))

   }

   TOCLine = which(htmlLines == TOC)

   if (length(TOCLine) == 1) {

      htmlLines = c(htmlLines[1 : {TOCLine - 1}], paste0(TOC, sub('X','Contenido',MET)), htmlLines[ - {1 : TOCLine}])

      htmlWrite = TRUE; message(crayon::blue(sub('content/post/', 'Fixed TOC in ', htmlFile)))

   }

   VOFLine = which(htmlLines == '.sourceCode { overflow: visible; }')

   if (length(VOFLine) == 1) {

      htmlLines = htmlLines[ - VOFLine]

      htmlWrite = TRUE; message(crayon::cyan(sub('content/post/', 'Fixed VOF in ', htmlFile)))

   }

   if(htmlWrite) writeLines(htmlLines, htmlFile) else message(sub('content/post/', 'All is OK in ', htmlFile))
}
