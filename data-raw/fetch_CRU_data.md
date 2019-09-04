CRU CL v. 2.0 Data for GSOD Station Locations
================

CRU CL v. 2.0 data are a gridded climatology of 1961-1990 monthly means
released in 2002 and cover all land areas (excluding Antarctica) at
10-minute (0.1666667 degree) resolution. For more information see the
description of the data provided by the University of East Anglia
Climate Research Unit (CRU),
<http://www.cru.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

# Download, extract and merge CRU data with provided GSOD climate data

## Setup the R session

``` r
# check for presence of countrycode package and install if needed
if (!require("getCRUCLdata")) {
  install.packages("getCRUCLdata", repos = "https://cran.rstudio.com/")
}
```

    ## Loading required package: getCRUCLdata

## Get CRU v. CL 2.0 data

``` r
CRU_stack <- getCRUCLdata::get_CRU_stack(pre = TRUE,
                                         rd0 = TRUE,
                                         tmp = TRUE,
                                         tmx = TRUE,
                                         tmn = TRUE,
                                         dtr = TRUE,
                                         reh = TRUE,
                                         sunp = TRUE,
                                         frs = TRUE,
                                         wnd = TRUE,
                                         cache = FALSE)
```

## Extract data for station locations

``` r
library(GSODR)

load(system.file("extdata", "isd_history.rda", package = "GSODR"))

stations <- as.data.frame(isd_history)
sp::coordinates(stations) <- ~ LON + LAT
crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
sp::proj4string(stations) <- sp::CRS(crs)
```

Now we will extract the data from the CRU CL 2.0 data at the GSOD
station locations.

``` r
# create a vector of names for the raster layers in new stack
CRU_stack_names <- c(
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[1]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[2]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[3]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[4]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[5]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[6]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[7]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
  paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[8]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
    paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[9]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  ),
    paste0(
    "CRU_CL_2_0_",
    names(CRU_stack[10]),
    "_",
    c(
      "01",
      "02",
      "03",
      "04",
      "05",
      "06",
      "07",
      "08",
      "09",
      "10",
      "11",
      "12"
    )
  )
)

# Create one stack object from list of stacks
CRU_stack <-  raster::stack(unlist(CRU_stack))

# Extract CRU data at GSOD station locations
CRU_GSOD <- raster::extract(CRU_stack, stations)

# Merge station ID and location with CRU data using na.omit to save space
CRU_CL_2 <- na.omit(data.frame(stations$STNID,
                               CRU_GSOD))
names(CRU_CL_2) <- c("STNID", CRU_stack_names)
```

## Save new data to disk for distribution with R package

``` r
usethis::use_data(CRU_CL_2, overwrite = TRUE, compress = "bzip2")
```

    ## ✔ Setting active project to '/Users/adamsparks/Development/GSODRdata'
    ## ✔ Saving 'CRU_CL_2' to 'data/CRU_CL_2.rda'

# Data reference and abstract

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)  
> A high-resolution data set of surface climate over global land areas
> Climate Research, 2000, Vol 21, pg 1-25  
> (1) School of Geography and the Environment, University of Oxford,
> Mansfield Road, Oxford OX1 3TB, United Kingdom  
> (2) Climatic Research Unit, and (3) Tyndall Centre for Climate Change
> Research, both at School of Environmental Sciences, University of East
> Anglia, Norwich NR4 7TJ, United Kingdom  
> (4) International Water Management Institute, PO Box 2“07”5, Colombo,
> Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute
> latitude/longitude data set of mean monthly surface climate over
> global land areas, excluding Antarctica. The climatology includes 8
> climate elements - precipitation, wet-day frequency, temperature,
> diurnal temperature range, relative humidity,sunshine duration, ground
> frost frequency and windspeed - and was interpolated from a data set
> of station means for the period centred on 1961 to 1990. Precipitation
> was first defined in terms of the parameters of the Gamma
> distribution, enabling the calculation of monthly precipitation at any
> given return period. The data are compared to an earlier data set at
> 0.5 degrees latitude/longitude resolution and show added value over
> most regions. The data will have many applications in applied
> climatology, biogeochemical modelling, hydrology and agricultural
> meteorology and are available through the School of Geography Oxford
> (<http://www.geog.ox.ac.uk>), the International Water Management
> Institute “World Water and Climate Atlas” (<http://www.iwmi.org>) and
> the Climatic Research Unit (<http://www.cru.uea.ac.uk>).

## R System Information

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.6.1 (2019-07-05)
    ##  os       macOS Mojave 10.14.6        
    ##  system   x86_64, darwin15.6.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2019-09-04                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package      * version date       lib source        
    ##  assertthat     0.2.1   2019-03-21 [1] CRAN (R 3.6.0)
    ##  backports      1.1.4   2019-04-10 [1] CRAN (R 3.6.0)
    ##  cli            1.1.0   2019-03-19 [1] CRAN (R 3.6.0)
    ##  clisymbols     1.2.0   2017-05-21 [1] CRAN (R 3.6.0)
    ##  codetools      0.2-16  2018-12-24 [2] CRAN (R 3.6.1)
    ##  crayon         1.3.4   2017-09-16 [1] CRAN (R 3.6.0)
    ##  curl           4.0     2019-07-22 [1] CRAN (R 3.6.1)
    ##  data.table     1.12.2  2019-04-07 [1] CRAN (R 3.6.0)
    ##  digest         0.6.20  2019-07-04 [1] CRAN (R 3.6.0)
    ##  evaluate       0.14    2019-05-28 [1] CRAN (R 3.6.0)
    ##  fs             1.3.1   2019-05-06 [1] CRAN (R 3.6.0)
    ##  getCRUCLdata * 0.3.1   2019-08-29 [1] CRAN (R 3.6.1)
    ##  glue           1.3.1   2019-03-12 [1] CRAN (R 3.6.0)
    ##  GSODR        * 2.0.0   2019-09-04 [1] CRAN (R 3.6.1)
    ##  hoardr         0.5.2   2018-12-02 [1] CRAN (R 3.6.0)
    ##  htmltools      0.3.6   2017-04-28 [1] CRAN (R 3.6.0)
    ##  knitr          1.24    2019-08-08 [1] CRAN (R 3.6.1)
    ##  lattice        0.20-38 2018-11-04 [2] CRAN (R 3.6.1)
    ##  magrittr       1.5     2014-11-22 [1] CRAN (R 3.6.0)
    ##  R6             2.4.0   2019-02-14 [1] CRAN (R 3.6.0)
    ##  rappdirs       0.3.1   2016-03-28 [1] CRAN (R 3.6.0)
    ##  raster         3.0-2   2019-08-22 [1] CRAN (R 3.6.0)
    ##  Rcpp           1.0.2   2019-07-25 [1] CRAN (R 3.6.0)
    ##  rgdal          1.4-4   2019-05-29 [1] CRAN (R 3.6.0)
    ##  rlang          0.4.0   2019-06-25 [1] CRAN (R 3.6.0)
    ##  rmarkdown      1.15    2019-08-21 [1] CRAN (R 3.6.0)
    ##  rprojroot      1.3-2   2018-01-03 [1] CRAN (R 3.6.0)
    ##  sessioninfo    1.1.1   2018-11-05 [1] CRAN (R 3.6.0)
    ##  sp             1.3-1   2018-06-05 [1] CRAN (R 3.6.0)
    ##  stringi        1.4.3   2019-03-12 [1] CRAN (R 3.6.0)
    ##  stringr        1.4.0   2019-02-10 [1] CRAN (R 3.6.0)
    ##  usethis        1.5.1   2019-07-04 [1] CRAN (R 3.6.0)
    ##  withr          2.1.2   2018-03-15 [1] CRAN (R 3.6.0)
    ##  xfun           0.9     2019-08-21 [1] CRAN (R 3.6.0)
    ##  yaml           2.2.0   2018-07-25 [1] CRAN (R 3.6.0)
    ## 
    ## [1] /Users/adamsparks/Library/R/3.x/library
    ## [2] /Library/Frameworks/R.framework/Versions/3.6/Resources/library
