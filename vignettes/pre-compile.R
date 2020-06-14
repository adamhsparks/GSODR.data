# vignettes that depend on internet access need to be pre-compiled
library("knitr")
knit("vignettes/Spatial.Rmd.orig", "vignettes/Spatial.Rmd")
knit(
  "vignettes/Using_GSODR_with_GSODRdata.Rmd.orig",
  "vignettes/Using_GSODR_with_GSODRdata.Rmd"
)

replace <-
  readLines("vignettes/Using_GSODR_with_GSODRdata.Rmd")
replace <-
  gsub("vignettes/",
       "",
       replace)
fileConn <-
  file("vignettes/Using_GSODR_with_GSODRdata.Rmd")
writeLines(replace, fileConn)
close(fileConn)

# build vignettes
library("devtools")
build_vignettes()

# move resource files to /doc
resources <-
  list.files("vignettes/", pattern = ".png$", full.names = TRUE)

resources <-
  file.copy(from = resources,
            to = "doc",
            overwrite =  TRUE)

# clean up stray files
unlink("vignettes/Temperatures_PHL_2010-2010.kmz")
