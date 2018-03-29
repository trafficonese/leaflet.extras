
# devtools::install("r-lib/pkgdown")

rmarkdown::render("README.Rmd")
pkgdown::build_site()
