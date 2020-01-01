# for pdf docs
x = "static/doctex"
blogdown::build_dir(x)
x = paste(x, dir(x), sep = "/")
file.remove(x[grep("\\.tex$", x)])

# for html slides
s = "static/docpres"
blogdown::build_dir(s)
s = paste(s, dir(s), sep = "/")
#(s[grep("_files$", s)])
