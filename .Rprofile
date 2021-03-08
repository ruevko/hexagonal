library(blogdown)

knitr::opts_chunk$set(message = FALSE, warning = FALSE)

options(stringsAsFactors = FALSE, digits = 4,
        blogdown.knit.serve_site = FALSE,
        blogdown.hugo.version = "0.81.0",
        blogdown.hugo.server = "-F")

my_build_site = function() { stop_server()
        # filter_timestamp(dir("content", ".Rmd$",, TRUE, TRUE))
        build_site(build_rmd = "timestamp", relativeURLs = FALSE)
}

my_new_post = function() sys.source("R/my_new_post.R")

set.seed(23)
