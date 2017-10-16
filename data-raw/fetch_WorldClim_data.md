WorldClim Data for GSOD Station Locations
================

WorldClim are freely available, average monthly climate data. Current conditions (interpolations of observed data, representative of 1960-1990) are freely available for download from <http://www.worldclim.org/version1>. Climatic elements include minimum, mean and maximum temperature and precipitation along with derived bioclimatic variables. WorldClim 1.4 (current conditions) are released under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Download, extract and merge WorldClim data with provided GSOD climate data
==========================================================================

The R package, [*raster*](https://cran.r-project.org/package=raster) offers facilities for downloading WorldClim data using the `getData()` function. The WorldClim data are available at several resolutions, for our purposes and ease of extracting the data we'll use the 2.5 arcminute (0.041666 degrees) resolution.

Setup the R session
-------------------

``` r
library(raster)
```

    ## Loading required package: sp

Get WorlClim Bio Data
---------------------

``` r
bioc <- raster::getData("worldclim", var = "bio", res = 2.5)
tmin <- raster::getData("worldclim", var = "tmin", res = 2.5)
tmax <- raster::getData("worldclim", var = "tmax", res = 2.5)
tavg <- raster::getData("worldclim", var = "tmean", res = 2.5)
prec <- raster::getData("worldclim", var = "prec", res = 2.5)
```

Extract Data for Station Locations
----------------------------------

``` r
stations <- readr::read_csv(
  "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv",
  col_types = "ccccccddddd",
  col_names = c("USAF", "WBAN", "STN_NAME", "CTRY", "STATE", "CALL",
                "LAT", "LON", "ELEV_M", "BEGIN", "END"), skip = 1)

stations[stations == -999.9] <- NA
stations[stations == -999] <- NA
stations <- stations[!is.na(stations$LAT) & !is.na(stations$LON), ]
stations <- stations[stations$LAT != 0 & stations$LON != 0, ]
stations <- stations[stations$LAT > -90 & stations$LAT < 90, ]
stations <- stations[stations$LON > -180 & stations$LON < 180, ]
stations <- stations[!is.na(stations$STN_NAME), ]
stations$STNID <- as.character(paste(stations$USAF, stations$WBAN, sep = "-"))

stations <- as.data.frame(stations)
sp::coordinates(stations) <- ~ LON + LAT
crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
sp::proj4string(stations) <- sp::CRS(crs)
```

Now we will extract the data from the WorldClim data at the GSOD station locations and merge them into data frames using `na.omit()` to remove NA values to save space. Note that temperature variables are automatically converted back to ˚C from [˚C \* 10](http://www.worldclim.org/current) in the GSODRdata package.

``` r
# Extract WorldClim data at GSOD station locations
WorldClim_tmin <- raster::extract(tmin, stations)/10
WorldClim_tmax <- raster::extract(tmax, stations)/10
WorldClim_tavg <- raster::extract(tavg, stations)/10
WorldClim_prec <- raster::extract(prec, stations)
WorldClim_Bio_GSOD <- raster::extract(bioc, stations)

# Climate data data frame
WorldClim_Clim <- na.omit(data.frame(stations$STNID,
                                     WorldClim_tmin,
                                     WorldClim_tmax,
                                     WorldClim_tavg,
                                     WorldClim_prec))
names(WorldClim_Clim)[1] <- c("STNID")

# Bioclimatic variables data frame
WorldClim_Bio <- na.omit(data.frame(stations$STNID,
                                    WorldClim_Bio_GSOD))
names(WorldClim_Bio)[1] <- c("STNID")
```

Save new data frames to disk for distribution with R package
------------------------------------------------------------

``` r
devtools::use_data(WorldClim_Clim, overwrite = TRUE, compress = "bzip2")
```

    ## Saving WorldClim_Clim as WorldClim_Clim.rda to /Users/U8004755/Development/GSODRdata/data

``` r
devtools::use_data(WorldClim_Bio, overwrite = TRUE, compress = "bzip2")
```

    ## Saving WorldClim_Bio as WorldClim_Bio.rda to /Users/U8004755/Development/GSODRdata/data

Reference
=========

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. Very high resolution interpolated climate surfaces for global land areas. International Journal of Climatology 25: 1965-1978.

R System Information
--------------------

    ## Session info -------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.4.2 (2017-09-28)
    ##  system   x86_64, darwin16.7.0        
    ##  ui       unknown                     
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2017-10-16

    ## Packages -----------------------------------------------------------------

    ##  package   * version    date       source                          
    ##  backports   1.1.1      2017-09-25 cran (@1.1.1)                   
    ##  base      * 3.4.2      2017-10-03 local                           
    ##  compiler    3.4.2      2017-10-03 local                           
    ##  curl        3.0        2017-10-06 cran (@3.0)                     
    ##  datasets  * 3.4.2      2017-10-03 local                           
    ##  devtools    1.13.3     2017-08-02 CRAN (R 3.4.1)                  
    ##  digest      0.6.12     2017-01-27 CRAN (R 3.4.1)                  
    ##  evaluate    0.10.1     2017-06-24 CRAN (R 3.4.1)                  
    ##  graphics  * 3.4.2      2017-10-03 local                           
    ##  grDevices * 3.4.2      2017-10-03 local                           
    ##  grid        3.4.2      2017-10-03 local                           
    ##  hms         0.3        2016-11-22 CRAN (R 3.4.1)                  
    ##  htmltools   0.3.6      2017-04-28 CRAN (R 3.4.1)                  
    ##  knitr       1.17       2017-08-10 CRAN (R 3.4.1)                  
    ##  lattice     0.20-35    2017-03-25 CRAN (R 3.4.2)                  
    ##  magrittr    1.5        2014-11-22 CRAN (R 3.4.1)                  
    ##  memoise     1.1.0      2017-04-21 CRAN (R 3.4.1)                  
    ##  methods   * 3.4.2      2017-10-03 local                           
    ##  R6          2.2.2      2017-06-17 CRAN (R 3.4.1)                  
    ##  raster    * 2.5-8      2016-06-02 CRAN (R 3.4.1)                  
    ##  Rcpp        0.12.13    2017-09-28 cran (@0.12.13)                 
    ##  readr       1.1.1      2017-05-16 CRAN (R 3.4.1)                  
    ##  rgdal       1.2-13     2017-10-07 cran (@1.2-13)                  
    ##  rlang       0.1.2.9000 2017-10-16 Github (tidyverse/rlang@2aacc28)
    ##  rmarkdown   1.6        2017-06-15 CRAN (R 3.4.1)                  
    ##  rprojroot   1.2        2017-01-16 CRAN (R 3.4.1)                  
    ##  sp        * 1.2-5      2017-06-29 CRAN (R 3.4.1)                  
    ##  stats     * 3.4.2      2017-10-03 local                           
    ##  stringi     1.1.5      2017-04-07 CRAN (R 3.4.1)                  
    ##  stringr     1.2.0      2017-02-18 CRAN (R 3.4.1)                  
    ##  tibble      1.3.4      2017-08-22 cran (@1.3.4)                   
    ##  tools       3.4.2      2017-10-03 local                           
    ##  utils     * 3.4.2      2017-10-03 local                           
    ##  withr       2.0.0      2017-09-17 Github (jimhester/withr@d1f0957)
    ##  yaml        2.1.14     2016-11-12 CRAN (R 3.4.1)
