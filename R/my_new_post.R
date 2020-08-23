my_post_filename = function (title, subdir, ext, date, lang = "", bundle = FALSE){

  file = tolower(title)

  bad = c("[[:digit:]]|[[:punct:]]", "\\b[[:alpha:]]{1,3}\\b", "\\s+", "^-|-$")

  bad = c(bad, "\U00F1", "\U00E1", "\U00E9", "\U00ED", "\U00F3", "\U00FA")

  good = c(" ", " ", "-", "", "n", "a", "e", "i", "o", "u")

  for(i in 1:10) file = gsub(bad[i], good[i], file)

  file = paste0(as.character(date, "%d-"), file)

  if (is.null(lang)) lang = ""

  d = dirname(file)

  f = basename(file)

  if (is.null(subdir) || subdir == "") subdir = "."

  d = if (d == ".") subdir else file.path(subdir, d)

  d = gsub("/+$", "", d)

  f = gsub("^([.]/)+", "", file.path(d, f))

  paste0(f, if (bundle) "/index", if (lang != "") ".", lang, ext)

}

# Just tweaking your addin, Yihui, thank you!

xfun::in_dir(blogdown:::site_root(), local({
  tags = htmltools::tags
  txt_input = function(..., width = '100%') shiny::textInput(..., width = width)
  sel_input = function(...) shiny::selectizeInput(..., width = '98%', options = list(create = TRUE))
  meta = blogdown:::collect_yaml()
  lang = NULL #blogdown:::check_lang()
  adir = blogdown:::theme_flag()
  adir = if (length(adir) == 4) file.path(adir[2], adir[4], 'archetypes')
  adir = c('archetypes', adir)
  shiny::runGadget(
    miniUI::miniPage(miniUI::miniContentPanel(
      txt_input('title', 'Title'),
      shiny::fillRow(
        sel_input('cat', 'Categories', c('', meta$categories)),
        sel_input('tag', 'Tags', meta$tags, multiple = TRUE),
        shiny::selectInput('kind', 'Archetype', xfun::sans_ext(rev(dir(adir))), width = '98%'),
        height = '70px'
      ),
      shiny::fillRow(
        txt_input('author', 'Author', getOption('blogdown.author', ''), width = '98%'),
        shiny::dateInput('date', 'Date', Sys.Date(), width = '98%'),
        txt_input('subdir', 'Subdirectory', getOption('blogdown.subdir', 'post'), width = '98%'),
        height = '70px'
      ),
      shiny::fillRow(txt_input('file', 'Filename', '', 'automatically generated'), height = '70px'),
      if (is.null(lang)) {
        shiny::fillRow(txt_input('slug', 'Slug', '', 'automatically generated'), height = '70px')
      } else {
        shiny::fillRow(
          txt_input('slug', 'Slug', '', 'automatically generated', width = '98%'),
          txt_input('lang', 'Language', lang, width = '98%'),
          height = '70px'
        )
      },
      shiny::radioButtons('format', '', c('Markdown' = '.md', 'R Markdown' = '.Rmd'), '.Rmd', TRUE),
      miniUI::gadgetTitleBar(NULL)
    )),
    server = function(input, output, session) {
      empty_title = shiny::reactive(grepl('^\\s*$', input$title))
      shiny::observe({
        if (!empty_title()) shiny::updateTextInput(
          session, 'file', value = my_post_filename(
            input$title, input$subdir, shiny::isolate(input$format), input$date, input$lang
          )
        )
      })
      shiny::observe({
        if (!grepl('^\\s*$', input$file)) shiny::updateTextInput(
          session, 'slug', value = blogdown:::post_slug(input$file)
        )
      })
      shiny::observeEvent(input$date, {
        shiny::updateTextInput(
          session, "subdir", value = as.character(input$date, "post/%Y/%m")
        )
      }, ignoreInit = TRUE)
      shiny::observeEvent(input$format, {
        if (input$file != '') shiny::updateTextInput(
          session, 'file', value = xfun::with_ext(input$file, input$format)
        )
      }, ignoreInit = TRUE)
      shiny::observeEvent(input$done, {
        if (grepl('^\\s*$', input$file)) return(warning('The filename is empty!', call. = FALSE))
        if (is.null(getOption('blogdown.author'))) options(blogdown.author = input$author)
        blogdown::new_post(
          title = input$title, author = input$author,
          categories = input$cat, tags = input$tag,
          file = input$file, subdir = input$subdir,
          slug = input$slug, ext = input$format,
          date = input$date, kind = input$kind
        )
        shiny::stopApp()
      })
      shiny::observeEvent(input$cancel, {
        shiny::stopApp()
      })
    },
    stopOnCancel = FALSE, viewer = shiny::dialogViewer('New Post', height = 500)
  )
}))
