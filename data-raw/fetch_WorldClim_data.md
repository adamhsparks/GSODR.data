WorldClim Data for GSOD Station Locations
================

WorldClim are freely available, average monthly climate data. Current conditions (interpolations of observed data, representative of 1960-1990) are freely available for download from <http://www.worldclim.org/version1>. Climatic elements include minimum, mean and maximum temperature and precipitation along with derived bioclimatic variables. WorldClim 1.4 (current conditions) are released under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Download, extract and merge WorldClim data with provided GSOD climate data
==========================================================================

The R package, [_raster_](https://cran.r-project.org/package=raster) offers facilities for downloading WorldClim data using the `getData()` function. The WorldClim data are available at several resolutions, for our purposes and ease of extracting the data we'll use the 2.5 arcminute (0.041666 degrees) resolution.

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

Extract data for station locations
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

    ## Saving WorldClim_Clim as WorldClim_Clim.rda to /Users/asparks/Development/GSODRdata/data

``` r
devtools::use_data(WorldClim_Bio, overwrite = TRUE, compress = "bzip2")
```

    ## Saving WorldClim_Bio as WorldClim_Bio.rda to /Users/asparks/Development/GSODRdata/data

R System Information
--------------------

    ## R version 3.3.3 (2017-03-06)
    ## Platform: x86_64-apple-darwin16.4.0 (64-bit)
    ## Running under: macOS Sierra 10.12.4
    ## 
    ## locale:
    ## [1] en_AU.UTF-8/en_AU.UTF-8/en_AU.UTF-8/C/en_AU.UTF-8/en_AU.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] raster_2.5-8 sp_1.2-4    
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10         knitr_1.15.1         magrittr_1.5        
    ##  [4] hms_0.3              devtools_1.12.0.9000 pkgload_0.0.0.9000  
    ##  [7] lattice_0.20-34      R6_2.2.0             stringr_1.2.0       
    ## [10] tools_3.3.3          pkgbuild_0.0.0.9000  rgdal_1.2-5         
    ## [13] grid_3.3.3           withr_1.0.2          htmltools_0.3.5     
    ## [16] yaml_2.1.14          rprojroot_1.2        digest_0.6.12       
    ## [19] tibble_1.3.0         readr_1.1.0          curl_2.4            
    ## [22] memoise_1.0.0        evaluate_0.10        rmarkdown_1.4.0.9000
    ## [25] stringi_1.1.3        backports_1.0.5

Reference
=========

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. Very high resolution interpolated climate surfaces for global land areas. International Journal of Climatology 25: 1965-1978.
