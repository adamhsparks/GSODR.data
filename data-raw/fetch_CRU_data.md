CRU CL v. 2.0 Data for GSOD Station Locations
================

CRU CL v. 2.0 data are a gridded climatology of 1961-1990 monthly means released in 2002 and cover all land areas (excluding Antarctica) at 10-minute (0.1666667 degree) resolution. For more information see the description of the data provided by the University of East Anglia Climate Research Unit (CRU), <http://www.cru.uea.ac.uk/cru/data/hrg/tmc/readme.txt>.

Download, extract and merge CRU data with provided GSOD climate data
====================================================================

Setup the R session
-------------------

``` r
library(getCRUCLdata)
```

Get CRU v. CL 2.0 data
----------------------

``` r
CRU_stack <- create_CRU_stack(pre = TRUE,
                              rd0 = TRUE,
                              tmp = TRUE,
                              dtr = TRUE,
                              reh = TRUE,
                              sunp = TRUE,
                              frs = TRUE,
                              wnd = TRUE)
```

    ##  
    ## Downloading requested data files.
    ## 

    ## 
      |                                                                       
      |                                                                 |   0%
      |                                                                       
      |========                                                         |  12%
      |                                                                       
      |================                                                 |  25%
      |                                                                       
      |========================                                         |  38%
      |                                                                       
      |================================                                 |  50%
      |                                                                       
      |=========================================                        |  62%
      |                                                                       
      |=================================================                |  75%
      |                                                                       
      |=========================================================        |  88%
      |                                                                       
      |=================================================================| 100%

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

Save new data to disk for distribution with R package
-----------------------------------------------------

``` r
devtools::use_data(CRU_CL_2, overwrite = TRUE, compress = "bzip2")
```

    ## Saving CRU_CL_2 as CRU_CL_2.rda to /Users/U8004755/Development/GSODRdata/data

R System Information
--------------------

    ## R version 3.3.3 (2017-03-06)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: OS X El Capitan 10.11.6
    ## 
    ## locale:
    ## [1] en_AU.UTF-8/en_AU.UTF-8/en_AU.UTF-8/C/en_AU.UTF-8/en_AU.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] getCRUCLdata_0.1.4
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10         knitr_1.15.1         raster_2.5-8        
    ##  [4] magrittr_1.5         devtools_1.12.0.9000 pkgload_0.0.0.9000  
    ##  [7] lattice_0.20-34      R6_2.2.0             stringr_1.2.0       
    ## [10] plyr_1.8.4           dplyr_0.5.0          tools_3.3.3         
    ## [13] pkgbuild_0.0.0.9000  rgdal_1.2-5          grid_3.3.3          
    ## [16] DBI_0.6              withr_1.0.2          htmltools_0.3.5     
    ## [19] yaml_2.1.14          assertthat_0.1       rprojroot_1.2       
    ## [22] digest_0.6.12        tibble_1.2           purrr_0.2.2         
    ## [25] readr_1.0.0          curl_2.3             memoise_1.0.0       
    ## [28] evaluate_0.10        rmarkdown_1.3.9004   sp_1.2-4            
    ## [31] stringi_1.1.2        backports_1.0.5

Data reference and abstract
===========================

> Mark New (1,\*), David Lister (2), Mike Hulme (3), Ian Makin (4)
> A high-resolution data set of surface climate over global land areas Climate Research, 2000, Vol 21, pg 1-25
> (1) School of Geography and the Environment, University of Oxford, Mansfield Road, Oxford OX1 3TB, United Kingdom
> (2) Climatic Research Unit, and (3) Tyndall Centre for Climate Change Research, both at School of Environmental Sciences, University of East Anglia, Norwich NR4 7TJ, United Kingdom
> (4) International Water Management Institute, PO Box 2"07"5, Colombo, Sri Lanka

> **ABSTRACT:** We describe the construction of a 10-minute latitude/longitude data set of mean monthly surface climate over global land areas, excluding Antarctica. The climatology includes 8 climate elements - precipitation, wet-day frequency, temperature, diurnal temperature range, relative humidity,sunshine duration, ground frost frequency and windspeed - and was interpolated from a data set of station means for the period centred on 1961 to 1990. Precipitation was first defined in terms of the parameters of the Gamma distribution, enabling the calculation of monthly precipitation at any given return period. The data are compared to an earlier data set at 0.5 degrees latitude/longitude resolution and show added value over most regions. The data will have many applications in applied climatology, biogeochemical modelling, hydrology and agricultural meteorology and are available through the School of Geography Oxford (<http://www.geog.ox.ac.uk>), the International Water Management Institute "World Water and Climate Atlas" (<http://www.iwmi.org>) and the Climatic Research Unit (<http://www.cru.uea.ac.uk>).
