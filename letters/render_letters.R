fn <-"usfs_rmrs_20210104.rmd"

# install.packages("komaletter")

# create draft
rmarkdown::draft(fn, template="pdf", package="komaletter", edit=FALSE)

# turn Rmd into a beautiful PDF
rmarkdown::render(fn)
