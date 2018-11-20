WorldClim Data for GSOD Station Locations
================

WorldClim are freely available, average monthly climate data. Current
conditions (interpolations of observed data, representative of
1960-1990) are freely available for download from
<http://www.worldclim.org/version1>. Climatic elements include minimum,
mean and maximum temperature and precipitation along with derived
bioclimatic variables. WorldClim 1.4 (current conditions) are released
under a [Creative Commons Attribution-ShareAlike 4.0 International
License](http://creativecommons.org/licenses/by-sa/4.0/).

# Download, extract and merge WorldClim data with provided GSOD climate data

The R package, [*raster*](https://cran.r-project.org/package=raster)
offers facilities for downloading WorldClim data using the `getData()`
function. The WorldClim data are available at several resolutions, for
our purposes and ease of extracting the data we’ll use the 2.5 arcminute
(0.041666 degrees) resolution.

## Setup the R session

``` r
library(raster)
```

    ## Loading required package: sp

## Get WorlClim Bio Data

``` r
bioc <- raster::getData("worldclim", var = "bio", res = 2.5)
tmin <- raster::getData("worldclim", var = "tmin", res = 2.5)
tmax <- raster::getData("worldclim", var = "tmax", res = 2.5)
tavg <- raster::getData("worldclim", var = "tmean", res = 2.5)
prec <- raster::getData("worldclim", var = "prec", res = 2.5)
```

## Extract Data for Station Locations

Load `GSODR` package and use the station location database from the
package.

``` r
library(GSODR)

load(system.file("extdata", "isd_history.rda", package = "GSODR"))

stations <- as.data.frame(isd_history)
sp::coordinates(stations) <- ~ LON + LAT
crs <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
sp::proj4string(stations) <- sp::CRS(crs)
```

Now we will extract the data from the WorldClim data at the GSOD station
locations and merge them into data frames using `na.omit()` to remove NA
values to save space. Note that temperature variables are automatically
converted back to ˚C from [˚C \* 10](http://www.worldclim.org/current)
in the GSODRdata package.

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

## Save new data frames to disk for distribution with R package

``` r
devtools::use_data(WorldClim_Clim, overwrite = TRUE, compress = "bzip2")
```

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## ✔ Setting active project to '/Users/asparks/Development/GSODRdata'
    ## ✔ Saving 'WorldClim_Clim' to 'data/WorldClim_Clim.rda'

``` r
devtools::use_data(WorldClim_Bio, overwrite = TRUE, compress = "bzip2")
```

    ## Warning: 'devtools::use_data' is deprecated.
    ## Use 'usethis::use_data()' instead.
    ## See help("Deprecated") and help("devtools-deprecated").

    ## ✔ Saving 'WorldClim_Bio' to 'data/WorldClim_Bio.rda'

# Reference

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005.
Very high resolution interpolated climate surfaces for global land
areas. International Journal of Climatology 25:
    1965-1978.

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
    ##  package     * version date       lib source                            
    ##  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.1)                    
    ##  backports     1.1.2   2017-12-13 [1] CRAN (R 3.5.1)                    
    ##  base64enc     0.1-3   2015-07-28 [1] CRAN (R 3.5.1)                    
    ##  callr         3.0.0   2018-08-24 [1] CRAN (R 3.5.1)                    
    ##  cli           1.0.1   2018-09-25 [1] CRAN (R 3.5.1)                    
    ##  clisymbols    1.2.0   2017-05-21 [1] CRAN (R 3.5.1)                    
    ##  codetools     0.2-15  2016-10-05 [2] CRAN (R 3.5.1)                    
    ##  colorout    * 1.2-0   2018-10-17 [1] Github (jalvesaq/colorout@cc5fbfa)
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.1)                    
    ##  desc          1.2.0   2018-05-01 [1] CRAN (R 3.5.1)                    
    ##  devtools      2.0.1   2018-10-26 [1] CRAN (R 3.5.1)                    
    ##  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.1)                    
    ##  evaluate      0.12    2018-10-09 [1] CRAN (R 3.5.1)                    
    ##  fs            1.2.6   2018-08-23 [1] CRAN (R 3.5.1)                    
    ##  glue          1.3.0   2018-07-17 [1] CRAN (R 3.5.1)                    
    ##  GSODR       * 1.3.0   2018-11-19 [1] CRAN (R 3.5.1)                    
    ##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.1)                    
    ##  knitr         1.20    2018-02-20 [1] CRAN (R 3.5.1)                    
    ##  lattice       0.20-35 2017-03-25 [2] CRAN (R 3.5.1)                    
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.1)                    
    ##  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.5.1)                    
    ##  pkgbuild      1.0.2   2018-10-16 [1] CRAN (R 3.5.1)                    
    ##  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.5.1)                    
    ##  prettyunits   1.0.2   2015-07-13 [1] CRAN (R 3.5.1)                    
    ##  processx      3.2.0   2018-08-16 [1] CRAN (R 3.5.1)                    
    ##  ps            1.2.1   2018-11-06 [1] CRAN (R 3.5.1)                    
    ##  R6            2.3.0   2018-10-04 [1] CRAN (R 3.5.1)                    
    ##  raster      * 2.8-4   2018-11-03 [1] CRAN (R 3.5.1)                    
    ##  Rcpp          1.0.0   2018-11-07 [1] CRAN (R 3.5.1)                    
    ##  remotes       2.0.2   2018-10-30 [1] CRAN (R 3.5.1)                    
    ##  rgdal         1.3-6   2018-10-16 [1] CRAN (R 3.5.1)                    
    ##  rlang         0.3.0.1 2018-10-25 [1] CRAN (R 3.5.1)                    
    ##  rmarkdown     1.10    2018-06-11 [1] CRAN (R 3.5.1)                    
    ##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.1)                    
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.1)                    
    ##  sp          * 1.3-1   2018-06-05 [1] CRAN (R 3.5.1)                    
    ##  stringi       1.2.4   2018-07-20 [1] CRAN (R 3.5.1)                    
    ##  stringr       1.3.1   2018-05-10 [1] CRAN (R 3.5.1)                    
    ##  testthat      2.0.1   2018-10-13 [1] CRAN (R 3.5.1)                    
    ##  usethis       1.4.0   2018-08-14 [1] CRAN (R 3.5.1)                    
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.1)                    
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.1)                    
    ## 
    ## [1] /Users/asparks/Library/R/3.x/library
    ## [2] /usr/local/Cellar/r/3.5.1/lib/R/library
