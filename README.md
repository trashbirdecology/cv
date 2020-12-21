
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cv

RMarkdown code for building CV and resumes from education, experience,
and awards stored as CSV files and publications stored as BibTeX file.
Code depends on vitae package. Template is combination of vitae::hyndman
and template by Steven Miller
(<http://svmiller.com/blog/2016/03/svm-r-markdown-cv/>).

# Example

``` r
# Job titles
job.titles <- read_csv("resume/job-titles.csv",
                      locale = locale(encoding = 'ISO-8859-1'),
                      col_types = cols(
                        begin = col_date("%m/%d/%y"),
                        end = col_date("%m/%d/%y")
                        )
)

# Job descriptions
job.descriptions <- read_csv("resume/job-descriptions.csv",
                      locale = locale(encoding = 'ISO-8859-1')
)
#> Parsed with column specification:
#> cols(
#>   jobId = col_double(),
#>   position = col_character(),
#>   employer = col_character(),
#>   accomplishments = col_character()
#> )

# Experience section
job.titles %>% 
  left_join(job.descriptions) %>% 
  vitae::detailed_entries(
    what = position,
    when = as.character(
      glue("{year(begin)} - {if_else(!is.na(end), as.character(year(end)), 'present')}")),
    with = employer,
    where = glue("{city}, {region}, {country}"),
    why = accomplishments) %>% 
  glimpse()
#> Joining, by = c("jobId", "position", "employer")
#> Observations: 7
#> Variables: 5
#> Groups: what, when, with, where [7]
#> $ what  <chr> "Post-doctoral Research Associate", "Graduate Research A...
#> $ when  <chr> "2016 - present", "2012 - 2016", "2014 - 2016", "2011 - ...
#> $ with  <chr> "University of Nebraska-Lincoln", "University of Florida...
#> $ where <S3: glue> "Lincoln, Nebraska, US", "Gainesville, Florida, US"...
#> $ why   <list> [<"Developed innovative approach to analyzing repeat-pu...
```
