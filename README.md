[![Travis-CI Build Status](https://travis-ci.org/adamhsparks/GSODRdata.svg?branch=master)](https://travis-ci.org/adamhsparks/GSODRdata)
[![Build status](https://ci.appveyor.com/api/projects/status/yf34qfha7662val4?svg=true)](https://ci.appveyor.com/project/adamhsparks/GSODRdata/branch/master?svg=true)
[![Coverage Status](https://img.shields.io/codecov/c/github/adamhsparks/GSODR.data/master.svg)](https://codecov.io/github/adamhsparks/GSODR.data?branch=master)

# GSODRdata

## Climate Data for the GSODR Package

This data-only package was created for distributing data useful for the GSODR
package and used in examples for the GSODR package.

Due to the installed package, 5.5Mb, this package is only available from GitHub.

Version: 1.0  
Authors: Adam Sparks, Tomislav Hengl, and Andrew Nelson  
Maintainer: Adam Sparks <adamhsparks@gmail.com>  
URL: https://github.com/adamhsparks/GSODRdata  
BugReports: https://github.com/adamhsparks/GSODRdata/issues  
Depends: R (>= 3.2.0)  
Suggests: [GSODR](https://cran.r-project.org/package=GSODR)

Four data frames of climate data are provided from various sources for GSOD
station locations.

  * **CHELSA** - [Climatic surfaces at 1 km resolution](http://chelsa-climate.org)
  is based on a quasi-mechanistic statistical downscaling of the ERA interim
  global circulation model (Karger et al. 2016). ESA's CCI-LC cloud probability
  monthly averages are based on the MODIS snow products (MOD10A2).

  * **CRU CL2.0** - The [CRU CL 2.0 data-set](https://crudata.uea.ac.uk/~timm/grid/CRU_CL_2_0.html) 
  (New et al. 2002) comprises monthly grids of observed mean climate from 
  1961-1990, and covering the global land surface at a 10 minute spatial
  resolution. There are eight climatic variables available, and also the
  elevations on the grid: diurnal temperature range, precipitation, mean
  temperature, wet-day frequency, frost-day frequency, relative humidity,
  sunshine, and wind-speed. In addition minimum and maximum temperature may be
  deduced from mean temperature and diurnal temperature range (see 
  [FAQ](https://crudata.uea.ac.uk/~timm/grid/faq.html)).

  * **ESACCI** - ESA's CCI-LC snow cover probability 
  <http://maps.elie.ucl.ac.be/CCI/viewer/index.php>

  * **MODCF** - [Remotely sensed high-resolution global cloud dynamics for predicting ecosystem and biodiversity distributions](https://github.com/adammwilson/Cloud)
  (Wilson et al. 2016) provides new near-global, fine-grain (≈1km) monthly cloud
  frequencies from 15 years of twice-daily MODIS satellite images.

If you find bugs, please file a report as an issue.

-----

## Quick Start

### Install

This package is only available from GitHub due to its large size. It 
provides optional data for use with the GSODR package, some of which are
demonstrated with examples in the GSODR documentation.

```r
install.packages("devtools")
devtools::install_github("adamhsparks/GSOD.data")
library("GSOD.data")
````

### Using GSOD.data

See the GSODR vignette, [Working with spatial and climate data](https://github.com/adamhsparks/GSODR/blob/master/vignettes/Working_with_spatial_and_climate_data.Rmd),
for use and examples.

-----

## References

Karger, D. N., Conrad, O., Bohner, J., Kawohl, T., Kreft, H., Soria-Auza, R. W.,
et al. (2016) Climatologies at high resolution for the Earth land surface
areas. arXiv preprint [arXiv:1607.00217](https://www.arxiv.org/abs/1607.00217).

New, M., Lister, D., Hulme, M. and Makin, I., (2002) A high-resolution data
set of surface climate over global land areas. Climate Research 21:1-25
([abstract](http://www.int-res.com/abstracts/cr/v21/n1/p1-25.html),
[paper](http://www.int-res.com/articles/cr2002/21/c021p001.pdf))

Wilson A.M., Jetz W. (2016) Remotely Sensed High-Resolution Global Cloud Dynamics for Predicting Ecosystem and Biodiversity Distributions. [PLoS Biol 14(3): e1002415. doi:10.1371/journal. pbio.1002415](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1002415)
