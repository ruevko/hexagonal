mapLines = readLines('docs/sitemap.xml', warn = FALSE)

mapLength = length(mapLines)

if (mapLines[mapLength - 4] != '    <lastmod>2020-01-01T00:00:00+00:00</lastmod>') {

   mapLines = c(mapLines[1 : {mapLength - 4}],
                '  </url><url>',
                '    <loc>https://ruevko.github.io/hexagonal/post/readme/</loc>',
                '    <lastmod>2020-01-01T00:00:00+00:00</lastmod>',
                '  </url><url>',
                mapLines[{mapLength - 2} : mapLength])

   writeLines(paste(mapLines, collapse = '\n'), 'docs/sitemap.xml', sep = '') }

message('\n\n  " Que cada hombre construya su propia catedral.\n',
        '    Para que vivir de obras de arte ajenas y antiguas?',
        ' "\n\n\t\t\t\t\t\t(Borges)\n\n')
