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
usethis::use_data(WorldClim_Clim, overwrite = TRUE, compress = "bzip2")
```

    ## ✓ Setting active project to '/Users/adamsparks/Sources/GitHub/R/GSODRdata'

    ## ✓ Saving 'WorldClim_Clim' to 'data/WorldClim_Clim.rda'

    ## ● Document your data (see 'https://r-pkgs.org/data.html')

``` r
usethis::use_data(WorldClim_Bio, overwrite = TRUE, compress = "bzip2")
```

    ## ✓ Saving 'WorldClim_Bio' to 'data/WorldClim_Bio.rda'
    ## ● Document your data (see 'https://r-pkgs.org/data.html')

# Reference

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005.
Very high resolution interpolated climate surfaces for global land
areas. International Journal of Climatology 25: 1965-1978.

## R System Information

    ## ─ Session info ───────────────────────────────────────────────────────────────
    ##  setting  value                       
    ##  version  R version 4.0.1 (2020-06-06)
    ##  os       macOS Catalina 10.15.5      
    ##  system   x86_64, darwin17.0          
    ##  ui       X11                         
    ##  language (EN)                        
    ##  collate  en_AU.UTF-8                 
    ##  ctype    en_AU.UTF-8                 
    ##  tz       Australia/Brisbane          
    ##  date     2020-06-13                  
    ## 
    ## ─ Packages ───────────────────────────────────────────────────────────────────
    ##  package     * version    date       lib source                             
    ##  assertthat    0.2.1      2019-03-21 [1] CRAN (R 4.0.0)                     
    ##  backports     1.1.7      2020-05-13 [1] CRAN (R 4.0.0)                     
    ##  cli           2.0.2      2020-02-28 [1] CRAN (R 4.0.0)                     
    ##  clisymbols    1.2.0      2017-05-21 [1] CRAN (R 4.0.0)                     
    ##  codetools     0.2-16     2018-12-24 [2] CRAN (R 4.0.1)                     
    ##  crayon        1.3.4.9000 2020-06-12 [1] Github (r-lib/crayon@dcf6d44)      
    ##  data.table    1.12.8     2019-12-09 [1] CRAN (R 4.0.0)                     
    ##  desc          1.2.0      2018-05-01 [1] CRAN (R 4.0.0)                     
    ##  digest        0.6.25     2020-02-23 [1] CRAN (R 4.0.0)                     
    ##  evaluate      0.14       2019-05-28 [1] CRAN (R 4.0.0)                     
    ##  fansi         0.4.1      2020-01-08 [1] CRAN (R 4.0.0)                     
    ##  fs            1.4.1      2020-04-04 [1] CRAN (R 4.0.0)                     
    ##  glue          1.4.1      2020-05-13 [1] CRAN (R 4.0.0)                     
    ##  GSODR       * 2.1.0.9000 2020-06-10 [1] CRAN (R 4.0.1)                     
    ##  htmltools     0.4.0      2019-10-04 [1] CRAN (R 4.0.0)                     
    ##  knitr         1.28       2020-02-06 [1] CRAN (R 4.0.0)                     
    ##  lattice       0.20-41    2020-04-02 [2] CRAN (R 4.0.1)                     
    ##  magrittr      1.5        2014-11-22 [1] CRAN (R 4.0.0)                     
    ##  prompt        1.0.0      2020-04-25 [1] Github (gaborcsardi/prompt@b332c42)
    ##  R6            2.4.1      2019-11-12 [1] CRAN (R 4.0.0)                     
    ##  raster      * 3.1-5      2020-04-19 [1] CRAN (R 4.0.0)                     
    ##  Rcpp          1.0.4.6    2020-04-09 [1] CRAN (R 4.0.0)                     
    ##  rgdal         1.5-8      2020-05-28 [1] CRAN (R 4.0.0)                     
    ##  rlang         0.4.6      2020-05-02 [1] CRAN (R 4.0.0)                     
    ##  rmarkdown     2.2        2020-05-31 [1] CRAN (R 4.0.0)                     
    ##  rprojroot     1.3-2      2018-01-03 [1] CRAN (R 4.0.0)                     
    ##  rstudioapi    0.11       2020-02-07 [1] CRAN (R 4.0.0)                     
    ##  sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 4.0.0)                     
    ##  sp          * 1.4-2      2020-05-20 [1] CRAN (R 4.0.0)                     
    ##  stringi       1.4.6      2020-02-17 [1] CRAN (R 4.0.0)                     
    ##  stringr       1.4.0      2019-02-10 [1] CRAN (R 4.0.0)                     
    ##  usethis       1.6.1      2020-04-29 [1] CRAN (R 4.0.0)                     
    ##  withr         2.2.0      2020-04-20 [1] CRAN (R 4.0.0)                     
    ##  xfun          0.14       2020-05-20 [1] CRAN (R 4.0.0)                     
    ##  yaml          2.2.1      2020-02-01 [1] CRAN (R 4.0.0)                     
    ## 
    ## [1] /Users/adamsparks/.R/library
    ## [2] /Library/Frameworks/R.framework/Versions/4.0/Resources/library
