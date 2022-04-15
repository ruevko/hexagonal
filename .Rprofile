library(blogdown)

knitr::opts_chunk$set(message = FALSE, warning = FALSE)

options(stringsAsFactors = FALSE, digits = 4,
        blogdown.knit.serve_site = FALSE,
        blogdown.hugo.version = "0.94.0",
        blogdown.hugo.server = "-F")

my_build_site = function() { stop_server()
        # filter_timestamp(dir("content", ".Rmd$",, TRUE, TRUE))
        build_site(build_rmd = "timestamp", relativeURLs = FALSE)
}

my_new_post = \() source("R/my_new_post.R") #knitr::spin("draft.R", FALSE) #TODO

set.seed(23)
