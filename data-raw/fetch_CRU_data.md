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

    ## 
    ## CRU CL 2.0 data are provided by the Climate Research Unit
    ## at the University of East Anglia. This data-set is owned by
    ## its author, Mark New. It is being distributed, where
    ## necessary by Tim Mitchell.
    ## 
    ## Users should refer to the published literature for details
    ## of it.
    ## 
    ## The data set may be freely used for non-commerical
    ## scientific and educational purposes, provided it is
    ## described as CRU CL 2.0 and attributed to:
    ## 
    ## New, M., Lister, D., Hulme, M. and Makin, I., 2002: A
    ## high-resolution data set of surface climate over global
    ## land areas. Climate Research 21:1-25
    ## 
    ## If you use getCRUCLdata, please cite it properly. For citation
    ## information see `citation(getCRUCLdata)`.

## Get CRU v. CL 2.0 data

``` r
CRU_stack <- getCRUCLdata::get_CRU_stack(pre = TRUE,
                                         rd0 = TRUE,
                                         tmp = TRUE,
                                         dtr = TRUE,
                                         reh = TRUE,
                                         sunp = TRUE,
                                         frs = TRUE,
                                         wnd = TRUE,
                                         cache = TRUE)
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

    ## Saving CRU_CL_2 as CRU_CL_2.rda to /Users/U8004755/Development/GSODRdata/data

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
    ##  version  R version 3.5.0 (2018-04-23)
    ##  os       macOS Sierra 10.12.6        
    ##  system   x86_64, darwin16.7.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2018-06-15                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package      * version date       source                         
    ##  backports      1.1.2   2017-12-13 CRAN (R 3.5.0)                 
    ##  clisymbols     1.2.0   2017-05-21 CRAN (R 3.5.0)                 
    ##  data.table     1.11.4  2018-05-27 CRAN (R 3.5.0)                 
    ##  devtools       1.13.5  2018-02-18 CRAN (R 3.5.0)                 
    ##  digest         0.6.15  2018-01-28 CRAN (R 3.5.0)                 
    ##  evaluate       0.10.1  2017-06-24 CRAN (R 3.5.0)                 
    ##  getCRUCLdata * 0.2.3   2018-05-17 CRAN (R 3.5.0)                 
    ##  GSODR        * 1.2.1   2018-06-15 Github (ropensci/GSODR@b4d804b)
    ##  hoardr         0.2.0   2017-05-10 CRAN (R 3.5.0)                 
    ##  htmltools      0.3.6   2017-04-28 CRAN (R 3.5.0)                 
    ##  knitr          1.20    2018-02-20 CRAN (R 3.5.0)                 
    ##  lattice        0.20-35 2017-03-25 CRAN (R 3.5.0)                 
    ##  magrittr       1.5     2014-11-22 CRAN (R 3.5.0)                 
    ##  memoise        1.1.0   2017-04-21 CRAN (R 3.5.0)                 
    ##  R6             2.2.2   2017-06-17 CRAN (R 3.5.0)                 
    ##  rappdirs       0.3.1   2016-03-28 CRAN (R 3.5.0)                 
    ##  raster         2.6-7   2017-11-13 CRAN (R 3.5.0)                 
    ##  Rcpp           0.12.17 2018-05-18 CRAN (R 3.5.0)                 
    ##  rgdal          1.3-2   2018-06-08 CRAN (R 3.5.0)                 
    ##  rlang          0.2.1   2018-05-30 CRAN (R 3.5.0)                 
    ##  rmarkdown      1.10    2018-06-11 CRAN (R 3.5.0)                 
    ##  rprojroot      1.3-2   2018-01-03 CRAN (R 3.5.0)                 
    ##  sessioninfo    1.0.0   2017-06-21 CRAN (R 3.5.0)                 
    ##  sp             1.3-1   2018-06-05 CRAN (R 3.5.0)                 
    ##  stringi        1.2.3   2018-06-12 cran (@1.2.3)                  
    ##  stringr        1.3.1   2018-05-10 CRAN (R 3.5.0)                 
    ##  withr          2.1.2   2018-03-15 CRAN (R 3.5.0)                 
    ##  yaml           2.1.19  2018-05-01 CRAN (R 3.5.0)
