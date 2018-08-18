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

    ## Saving WorldClim_Clim as WorldClim_Clim.rda to /Users/adamsparks/Development/GSODRdata/data

``` r
devtools::use_data(WorldClim_Bio, overwrite = TRUE, compress = "bzip2")
```

    ## Saving WorldClim_Bio as WorldClim_Bio.rda to /Users/adamsparks/Development/GSODRdata/data

# Reference

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005.
Very high resolution interpolated climate surfaces for global land
areas. International Journal of Climatology 25:
    1965-1978.

## R System Information

    ## ─ Session info ──────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 3.5.1 (2018-07-02)
    ##  os       macOS High Sierra 10.13.6   
    ##  system   x86_64, darwin17.7.0        
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2018-08-17                  
    ## 
    ## ─ Packages ──────────────────────────────────────────────────────────────
    ##  package     * version date       source                            
    ##  backports     1.1.2   2017-12-13 CRAN (R 3.5.1)                    
    ##  clisymbols    1.2.0   2017-05-21 CRAN (R 3.5.1)                    
    ##  colorout    * 1.2-0   2018-08-16 Github (jalvesaq/colorout@cc5fbfa)
    ##  devtools      1.13.6  2018-06-27 CRAN (R 3.5.1)                    
    ##  digest        0.6.15  2018-01-28 CRAN (R 3.5.1)                    
    ##  evaluate      0.11    2018-07-17 CRAN (R 3.5.1)                    
    ##  GSODR       * 1.2.1   2018-06-16 CRAN (R 3.5.1)                    
    ##  htmltools     0.3.6   2017-04-28 CRAN (R 3.5.1)                    
    ##  knitr         1.20    2018-02-20 CRAN (R 3.5.1)                    
    ##  lattice       0.20-35 2017-03-25 CRAN (R 3.5.1)                    
    ##  magrittr      1.5     2014-11-22 CRAN (R 3.5.1)                    
    ##  memoise       1.1.0   2017-04-21 CRAN (R 3.5.1)                    
    ##  raster      * 2.6-7   2017-11-13 CRAN (R 3.5.1)                    
    ##  Rcpp          0.12.18 2018-07-23 CRAN (R 3.5.1)                    
    ##  rgdal         1.3-4   2018-08-03 CRAN (R 3.5.1)                    
    ##  rlang         0.2.2   2018-08-16 CRAN (R 3.5.1)                    
    ##  rmarkdown     1.10    2018-06-11 CRAN (R 3.5.1)                    
    ##  rprojroot     1.3-2   2018-01-03 CRAN (R 3.5.1)                    
    ##  sessioninfo   1.0.0   2017-06-21 CRAN (R 3.5.1)                    
    ##  sp          * 1.3-1   2018-06-05 CRAN (R 3.5.1)                    
    ##  stringi       1.2.4   2018-07-20 CRAN (R 3.5.1)                    
    ##  stringr       1.3.1   2018-05-10 CRAN (R 3.5.1)                    
    ##  withr         2.1.2   2018-03-15 CRAN (R 3.5.1)                    
    ##  yaml          2.2.0   2018-07-25 CRAN (R 3.5.1)
