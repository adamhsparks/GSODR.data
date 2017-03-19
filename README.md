[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/GSODRdata.svg?branch=master)](https://travis-ci.org/adamhsparks/GSODRdata)
[![Build status](https://ci.appveyor.com/api/projects/status/yf34qfha7662val4/branch/master?svg=true)](https://ci.appveyor.com/api/projects/status/yf34qfha7662val4/branch/master?svg=true)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/GSODRdata)]()
[![DOI](https://zenodo.org/badge/78181238.svg)](https://zenodo.org/badge/latestdoi/78181238)

# GSODRdata

## Climate Data for the GSODR Package

This data-only package was created for distributing data useful for the GSODR
package and used in examples for the GSODR package.

Due to the installed package, >9Mb, this package is only available from GitHub.

Authors: Adam Sparks, Tomislav Hengl, and Andrew Nelson  
Maintainer: Adam Sparks <adamhsparks@gmail.com>  
URL: https://github.com/adamhsparks/GSODRdata  
BugReports: https://github.com/adamhsparks/GSODRdata/issues  
Depends: R (>= 3.2.0)  
Depends: [GSODR](https://cran.r-project.org/package=GSODR)

Six data frames of climate data are provided from various sources for GSOD station locations.

  * **CHELSA** - [Climatic surfaces at 1 km resolution](http://chelsa-climate.org)
  is based on a quasi-mechanistic statistical downscaling of the ERA-Interim global circulation model (Karger et al. 2016). ESA's CCI-LC cloud probability monthly averages are based on the MODIS snow products (MOD10A2).

  * **CRU CL2.0** - The [CRU CL 2.0 data-set](https://crudata.uea.ac.uk/~timm/grid/CRU_CL_2_0.html) 
  (New et al. 2002) comprises monthly grids of observed mean climate from 1961-1990, and covering the global land surface at a 10 minute (0.1666667 degree) spatial resolution. There are eight climatic elements available on the grid: diurnal temperature range, precipitation, mean temperature, wet-day frequency, frost-day frequency, relative humidity, sunshine, and wind-speed, , and also the elevation. In addition minimum and maximum temperature may be deduced from mean temperature and diurnal temperature range (see [FAQ](https://crudata.uea.ac.uk/~timm/grid/faq.html)).

  * **ESACCI** - ESA's CCI-LC snow cover probability 
  <http://maps.elie.ucl.ac.be/CCI/viewer/index.php>

  * **MODCF** - [Remotely sensed high-resolution global cloud dynamics for predicting ecosystem and biodiversity distributions](https://github.com/adammwilson/Cloud)
  (Wilson et al. 2016) provides new near-global, fine-grain (≈1km) monthly cloud frequencies from 15 years of twice-daily MODIS satellite images.
  
  * **WorlClim_Bio** - [WorlClim Global Climate Data - Free climate data for ecological modeling and GIS](http://www.worldclim.org/version1)
  (Hijmans et al. 2004) provides freely available, average monthly climate data. Current
conditions (interpolations of observed data, representative of 1960-1990)
are freely available for download from http://www.worldclim.org/version1.

  * **WorlClim_Clim** - [WorlClim Global Climate Data - Free climate data for ecological modeling and GIS](http://www.worldclim.org/version1)
  (Hijmans et al. 2004) provides freely available, average monthly climate data. Current
conditions (interpolations of observed data, representative of 1960-1990)
are freely available for download from http://www.worldclim.org/version1.

-----

## Quick Start

### Install

This package is only available from GitHub due to its large size. It provides optional data for use with the [GSODR package](http://adamhsparks.github.io/GSODR/), some of which are demonstrated with examples in the [GSODR documentation](http://adamhsparks.github.io/GSODR/articles/index.html).

```r
#install.packages("devtools")
devtools::install_github("adamhsparks/GSODRdata")
library("GSODRdata")
````

### Using `GSODRdata`

See the `GSODR` vignette, [Working with spatial and climate data](http://ropensci.github.io/GSODR/articles/Working_with_spatial_and_climate_data.html), for use and examples.

-----

# Meta 
If you find bugs, please [file a report as an issue](https://github.com/adamhsparks/GSODRdata/issues).

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

## References

Karger, D. N., Conrad, O., Bohner, J., Kawohl, T., Kreft, H., Soria-Auza, R. W., *et al*. (2016) Climatologies at high resolution for the Earth land surface areas. *arXiv preprint* [**arXiv:1607.00217**](https://www.arxiv.org/abs/1607.00217).

New, M., Lister, D., Hulme, M., Makin, I. (2002) A high-resolution data set of surface climate over global land areas. *Climate Research* **21**:1--25
([abstract](https://crudata.uea.ac.uk/cru/data/hrg/tmc/readme.txt), [paper](http://www.int-res.com/articles/cr2002/21/c021p001.pdf))

Wilson, A. M., Jetz, W. (2016) Remotely Sensed High-Resolution Global Cloud Dynamics for Predicting Ecosystem and Biodiversity Distributions. [*PLoS Biol* **14(3)**: e1002415. doi:10.1371/journal. pbio.1002415](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002415)

Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A. Jarvis, 2005. Very 
high resolution interpolated climate surfaces for global land areas. 
*International Journal of Climatology* **25**: 1965-1978.
