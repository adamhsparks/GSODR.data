[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/GSODRdata.svg?branch=master)](https://travis-ci.org/adamhsparks/GSODRdata)
[![Build status](https://ci.appveyor.com/api/projects/status/yf34qfha7662val4/branch/master?svg=true)](https://ci.appveyor.com/api/projects/status/yf34qfha7662val4/branch/master?svg=true)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/GSODRdata)]()
[![DOI](https://zenodo.org/badge/78181238.svg)](https://zenodo.org/badge/latestdoi/78181238)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

# _GSODRdata_

## Climate and Ecological Data for the _GSODR_ Package

This data-only package was created for distributing data useful with [_GSODR_](https://ropensci.github.io/GSODR/)
and used in examples for the [_GSODR_ package vignettes](https://github.com/ropensci/GSODR/blob/master/vignettes/Working_with_spatial_and_climate_data.Rmd).

Due to the installed package, >9Mb, this package is only available from 
[GitHub](https://github.com/adamhsparks/GSODRdata/).

Authors: Adam Sparks, Tomislav Hengl, and Andrew Nelson  
Maintainer: Adam Sparks <adamhsparks@gmail.com>  
URL: https://github.com/adamhsparks/GSODRdata  
BugReports: https://github.com/adamhsparks/GSODRdata/issues  
Depends: R (>= 3.2.0)  
Suggests: [GSODR](https://cran.r-project.org/package=GSODR)

Six data frames of climate data are provided from various sources for GSOD station locations and can be joined with data formatted by the _GSODR_ package using the `STNID` column.


  * **CHELSA** - [Climatic surfaces at 1 km resolution](http://chelsa-climate.org)
  is based on a quasi-mechanistic statistical down scaling of the ERA interim global circulation model (Karger *et al.* 2016). ESA's CCI-LC cloud probability monthly averages are based on the MODIS snow products (MOD10A2).

  * **CRU_CL_2** - The [CRU CL v. 2.0 data-set](https://crudata.uea.ac.uk/~timm/grid/CRU_CL_2_0.html) 
  (New *et al.* 2002) comprises monthly grids of observed mean climate from 1961-1990, and covering the global land surface at a 10 minute spatial resolution. There are eight climatic variables available, and also the elevations on the grid: diurnal temperature range, precipitation, mean temperature, wet-day frequency, frost-day frequency, relative humidity, sunshine, and wind-speed. Minimum and maximum temperature are also
  calculated using [getCRUCLdata](https://ropensci.github.io/getCRUCLdata/) and
  included in this data set, (see
  [FAQ](https://crudata.uea.ac.uk/~timm/grid/faq.html)).

  * **ESACCI** - ESA's CCI-LC snow cover probability 
  <http://maps.elie.ucl.ac.be/CCI/viewer/index.php>.

  * **MODCF** - [Remotely sensed high-resolution global cloud dynamics for predicting ecosystem and biodiversity distributions](https://github.com/adammwilson/Cloud) (Wilson *et al.* 2016) provides new near-global, fine-grain (≈1km) monthly cloud frequencies from 15 years of twice-daily MODIS satellite images.
  
  * **WorldClim_Bio 1.4** - [WorldClim Global Climate Data - Free climate data for ecological modeling and GIS](http://www.worldclim.org/version1)
  (Hijmans et al. 2004) provides freely available [bioclimatic variables](http://worldclim.org/bioclim).
These data are freely available for download from http://www.worldclim.org/version1.

  * **WorldClim_Clim 1.4** - [WorldClim Global Climate Data - Free climate data for ecological modeling and GIS](http://www.worldclim.org/version1)
  (Hijmans et al. 2004) provides freely available, average monthly climate data. Current
conditions (interpolations of observed data, representative of 1960-1990)
are freely available for download from http://www.worldclim.org/version1.

-----

i## Quick Start

### Install

This package is only available from GitHub due to its large size. It provides optional data for use with the [_GSODR_ package](http://adamhsparks.github.io/GSODR/), some of which are demonstrated with examples in the [_GSODR_ documentation](http://adamhsparks.github.io/GSODR/articles/index.html).

```r
#install.packages("remotes")
remotes::install_github("adamhsparks/GSODRdata", build_vignettes = TRUE)
library("GSODRdata")
````

### Using _GSODRdata_

See the _GSODR_ vignette, [Working with spatial and climate data from GSODR and GSODRdata](https://ropensci.github.io/GSODR/articles/Working_with_spatial_and_climate_data.html), for use and examples.

### Keeping _GSODRdata_ updated

With each new release of _GSODR_, the _GSODRdata_ package is also updated. To
keep your local installation up-to-date, please use:

```r
devtools::update_packages("GSODRdata")
```

-----

# Meta 

If you find bugs or have an idea to make this package better, please [file a report with us](https://github.com/adamhsparks/GSODRdata/issues).

License: MIT

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

## References

Karger, D. N., Conrad, O., Bohner, J., Kawohl, T., Kreft, H., Soria-Auza, R. W., *et al*. (2016) Climatologies at high resolution for the Earth land surface areas. *arXiv preprint* [**arXiv:1607.00217**](https://www.arxiv.org/abs/1607.00217).

New, M., Lister, D., Hulme, M., Makin, I. (2002) A high-resolution data set of surface climate over global land areas. *Climate Research* **21**:1-25 ([abstract](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt), [paper](http://www.int-res.com/articles/cr2002/21/c021p001.pdf))

Wilson, A. M., Jetz, W. (2016) Remotely Sensed High-Resolution Global Cloud Dynamics for Predicting Ecosystem and Biodiversity Distributions. [*PLoS Biol* **14(3)**: e1002415. doi:10.1371/journal. pbio.1002415](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002415)

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. Very 
high resolution interpolated climate surfaces for global land areas. 
*International Journal of Climatology* **25**:1965-1978.
