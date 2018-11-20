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
                                         cache = TRUE)
```

    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |=========                                                        |  14%
      |                                                                       
      |===================                                              |  29%
      |                                                                       
      |============================                                     |  43%
      |                                                                       
      |=====================================                            |  57%
      |                                                                       
      |==============================================                   |  71%
      |                                                                       
      |========================================================         |  86%
      |                                                                       
      |=================================================================| 100%

    ## Warning in data.table::fread(paste0("gzip -dc ", files[[1]]), header =
    ## FALSE): Discarded single-line footer: <<21.583 14.750 15.2 16.3 15.9 17.0
    ## 16.4 16.1 14.4 14.2 >>

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
devtools::use_data(CRU_CL_2, overwrite = TRUE, compress = "bzip2")
```

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## ✔ Setting active project to '/Users/asparks/Development/GSODRdata'
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
> the Climatic Research Unit
    (<http://www.cru.uea.ac.uk>).

## R System Information

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.5.1 (2018-07-02)
    ##  os       macOS  10.14.1              
    ##  system   x86_64, darwin18.0.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2018-11-20                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package      * version date       lib source                            
    ##  assertthat     0.2.0   2017-04-11 [1] CRAN (R 3.5.1)                    
    ##  backports      1.1.2   2017-12-13 [1] CRAN (R 3.5.1)                    
    ##  base64enc      0.1-3   2015-07-28 [1] CRAN (R 3.5.1)                    
    ##  callr          3.0.0   2018-08-24 [1] CRAN (R 3.5.1)                    
    ##  cli            1.0.1   2018-09-25 [1] CRAN (R 3.5.1)                    
    ##  clisymbols     1.2.0   2017-05-21 [1] CRAN (R 3.5.1)                    
    ##  codetools      0.2-15  2016-10-05 [2] CRAN (R 3.5.1)                    
    ##  colorout     * 1.2-0   2018-10-17 [1] Github (jalvesaq/colorout@cc5fbfa)
    ##  crayon         1.3.4   2017-09-16 [1] CRAN (R 3.5.1)                    
    ##  curl           3.2     2018-03-28 [1] CRAN (R 3.5.1)                    
    ##  data.table     1.11.8  2018-09-30 [1] CRAN (R 3.5.1)                    
    ##  desc           1.2.0   2018-05-01 [1] CRAN (R 3.5.1)                    
    ##  devtools       2.0.1   2018-10-26 [1] CRAN (R 3.5.1)                    
    ##  digest         0.6.18  2018-10-10 [1] CRAN (R 3.5.1)                    
    ##  evaluate       0.12    2018-10-09 [1] CRAN (R 3.5.1)                    
    ##  fs             1.2.6   2018-08-23 [1] CRAN (R 3.5.1)                    
    ##  getCRUCLdata * 0.2.5   2018-09-12 [1] CRAN (R 3.5.1)                    
    ##  glue           1.3.0   2018-07-17 [1] CRAN (R 3.5.1)                    
    ##  GSODR        * 1.3.0   2018-11-19 [1] CRAN (R 3.5.1)                    
    ##  hoardr         0.5.0   2018-10-13 [1] CRAN (R 3.5.1)                    
    ##  htmltools      0.3.6   2017-04-28 [1] CRAN (R 3.5.1)                    
    ##  httr           1.3.1   2017-08-20 [1] CRAN (R 3.5.1)                    
    ##  knitr          1.20    2018-02-20 [1] CRAN (R 3.5.1)                    
    ##  lattice        0.20-35 2017-03-25 [2] CRAN (R 3.5.1)                    
    ##  magrittr       1.5     2014-11-22 [1] CRAN (R 3.5.1)                    
    ##  memoise        1.1.0   2017-04-21 [1] CRAN (R 3.5.1)                    
    ##  pkgbuild       1.0.2   2018-10-16 [1] CRAN (R 3.5.1)                    
    ##  pkgload        1.0.2   2018-10-29 [1] CRAN (R 3.5.1)                    
    ##  prettyunits    1.0.2   2015-07-13 [1] CRAN (R 3.5.1)                    
    ##  processx       3.2.0   2018-08-16 [1] CRAN (R 3.5.1)                    
    ##  ps             1.2.1   2018-11-06 [1] CRAN (R 3.5.1)                    
    ##  R6             2.3.0   2018-10-04 [1] CRAN (R 3.5.1)                    
    ##  rappdirs       0.3.1   2016-03-28 [1] CRAN (R 3.5.1)                    
    ##  raster         2.8-4   2018-11-03 [1] CRAN (R 3.5.1)                    
    ##  Rcpp           1.0.0   2018-11-07 [1] CRAN (R 3.5.1)                    
    ##  remotes        2.0.2   2018-10-30 [1] CRAN (R 3.5.1)                    
    ##  rgdal          1.3-6   2018-10-16 [1] CRAN (R 3.5.1)                    
    ##  rlang          0.3.0.1 2018-10-25 [1] CRAN (R 3.5.1)                    
    ##  rmarkdown      1.10    2018-06-11 [1] CRAN (R 3.5.1)                    
    ##  rprojroot      1.3-2   2018-01-03 [1] CRAN (R 3.5.1)                    
    ##  sessioninfo    1.1.1   2018-11-05 [1] CRAN (R 3.5.1)                    
    ##  sp             1.3-1   2018-06-05 [1] CRAN (R 3.5.1)                    
    ##  stringi        1.2.4   2018-07-20 [1] CRAN (R 3.5.1)                    
    ##  stringr        1.3.1   2018-05-10 [1] CRAN (R 3.5.1)                    
    ##  testthat       2.0.1   2018-10-13 [1] CRAN (R 3.5.1)                    
    ##  usethis        1.4.0   2018-08-14 [1] CRAN (R 3.5.1)                    
    ##  withr          2.1.2   2018-03-15 [1] CRAN (R 3.5.1)                    
    ##  yaml           2.2.0   2018-07-25 [1] CRAN (R 3.5.1)                    
    ## 
    ## [1] /Users/asparks/Library/R/3.x/library
    ## [2] /usr/local/Cellar/r/3.5.1/lib/R/library
