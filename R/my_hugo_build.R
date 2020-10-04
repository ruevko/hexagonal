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

tomlLines = readLines('config.toml')

writeLines(tomlLines[ - 13], 'config.toml')

blogdown::hugo_build()

writeLines(tomlLines, 'config.toml')

xmlLines = readLines('docs/sitemap.xml', warn = FALSE)

xmlLength = length(xmlLines)

if (xmlLines[xmlLength - 7] != '    <lastmod>2020-01-01T00:00:00+00:00</lastmod>') {

   xmlLines = c(xmlLines[1 : {xmlLength - 5}],
                '  <url>',
                '    <loc>https://ruevko.github.io/hexagonal/post/readme/</loc>',
                '    <lastmod>2020-01-01T00:00:00+00:00</lastmod>',
                '  </url>',
                xmlLines[{xmlLength - 5} : xmlLength])

   writeLines(paste(xmlLines, collapse = '\n'), 'docs/sitemap.xml', sep = '')

}
