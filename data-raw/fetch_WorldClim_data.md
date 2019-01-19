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

    ## ✔ Setting active project to '/Users/adamsparks/Development/GSODRdata'
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
    ##  version  R version 3.5.2 (2018-12-20)
    ##  os       macOS Mojave 10.14.2        
    ##  system   x86_64, darwin18.2.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2019-01-19                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       lib source        
    ##  assertthat    0.2.0   2017-04-11 [1] CRAN (R 3.5.2)
    ##  backports     1.1.3   2018-12-14 [1] CRAN (R 3.5.2)
    ##  callr         3.1.1   2018-12-21 [1] CRAN (R 3.5.2)
    ##  cli           1.0.1   2018-09-25 [1] CRAN (R 3.5.2)
    ##  clisymbols    1.2.0   2017-05-21 [1] CRAN (R 3.5.2)
    ##  codetools     0.2-15  2016-10-05 [3] CRAN (R 3.5.2)
    ##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.5.2)
    ##  desc          1.2.0   2018-05-01 [1] CRAN (R 3.5.2)
    ##  devtools      2.0.1   2018-10-26 [1] CRAN (R 3.5.2)
    ##  digest        0.6.18  2018-10-10 [1] CRAN (R 3.5.2)
    ##  evaluate      0.12    2018-10-09 [1] CRAN (R 3.5.2)
    ##  fs            1.2.6   2018-08-23 [1] CRAN (R 3.5.2)
    ##  glue          1.3.0   2018-07-17 [1] CRAN (R 3.5.2)
    ##  GSODR       * 1.3.2   2019-01-19 [1] CRAN (R 3.5.2)
    ##  htmltools     0.3.6   2017-04-28 [1] CRAN (R 3.5.2)
    ##  knitr         1.21    2018-12-10 [1] CRAN (R 3.5.2)
    ##  lattice       0.20-38 2018-11-04 [3] CRAN (R 3.5.2)
    ##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.5.2)
    ##  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.5.2)
    ##  pkgbuild      1.0.2   2018-10-16 [1] CRAN (R 3.5.2)
    ##  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.5.2)
    ##  prettyunits   1.0.2   2015-07-13 [1] CRAN (R 3.5.2)
    ##  processx      3.2.1   2018-12-05 [1] CRAN (R 3.5.2)
    ##  ps            1.3.0   2018-12-21 [1] CRAN (R 3.5.2)
    ##  R6            2.3.0   2018-10-04 [1] CRAN (R 3.5.2)
    ##  raster      * 2.8-4   2018-11-03 [1] CRAN (R 3.5.2)
    ##  Rcpp          1.0.0   2018-11-07 [1] CRAN (R 3.5.2)
    ##  remotes       2.0.2   2018-10-30 [1] CRAN (R 3.5.2)
    ##  rgdal         1.3-6   2018-10-16 [1] CRAN (R 3.5.2)
    ##  rlang         0.3.1   2019-01-08 [1] CRAN (R 3.5.2)
    ##  rmarkdown     1.11    2018-12-08 [1] CRAN (R 3.5.2)
    ##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.5.2)
    ##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.5.2)
    ##  sp          * 1.3-1   2018-06-05 [1] CRAN (R 3.5.2)
    ##  stringi       1.2.4   2018-07-20 [1] CRAN (R 3.5.2)
    ##  stringr       1.3.1   2018-05-10 [1] CRAN (R 3.5.2)
    ##  testthat      2.0.1   2018-10-13 [1] CRAN (R 3.5.2)
    ##  usethis       1.4.0   2018-08-14 [1] CRAN (R 3.5.2)
    ##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.5.2)
    ##  xfun          0.4     2018-10-23 [1] CRAN (R 3.5.2)
    ##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.5.2)
    ## 
    ## [1] /Users/adamsparks/Library/R/3.x/library
    ## [2] /usr/local/lib/R/3.5/site-library
    ## [3] /usr/local/Cellar/r/3.5.2/lib/R/library
