#' WorldClim_Clim
#' @format A data frame with 26231 observations of 51 variables:
#' \describe{
#' \item{tmin1} {Annual Mean Minimum Temperature for January}
#' \item{bio2} {Mean Diurnal Range (Mean of monthly (max temp - min temp))}
#' \item{bio3} {Isothermality (#' \item{bio2/#' \item{bio7) (* 100)}
#' \item{bio4} {Temperature Seasonality (standard deviation *100)}
#' \item{bio5} {Max Temperature of Warmest Month}
#' \item{bio6} {Min Temperature of Coldest Month}
#' \item{bio7} {Temperature Annual Range (#' \item{bio5-#' \item{bio6)}
#' \item{bio8} {Mean Temperature of Wettest Quarter}
#' \item{bio9} {Mean Temperature of Driest Quarter}
#' \item{bio10} {Mean Temperature of Warmest Quarter}
#' \item{bio11} {Mean Temperature of Coldest Quarter}
#' \item{bio12} {Annual Precipitation}
#' \item{bio13} {Precipitation of Wettest Month}
#' \item{bio14} {Precipitation of Driest Month}
#' \item{bio15} {Precipitation Seasonality (Coefficient of Variation)}
#' \item{bio16} {Precipitation of Wettest Quarter}
#' \item{bio17} {Precipitation of Driest Quarter}
#' \item{bio18} {Precipitation of Warmest Quarter}
#' \item{bio19} {Precipitation of Coldest Quarter}
#'}
#' @source WorlClim Global Climate Data - Free climate data for ecological
#' modeling and GIS \link{http://www.worldclim.org/bioclim}.
#'
#' WorldClim are freely available, average monthly climate data. Current
#' conditions (interpolations of observed data, representative of 1960-1990)
#' are freely available for download from \link{http://www.worldclim.org/version1}.
#' Climatic elements include minimum, mean and maximum temperature and
#' precipitation along with derived bioclimatic variables. WorldClim 1.4
#' (current conditions) are released under a Creative Commons
#' Attribution-ShareAlike 4.0 International License
#' \link{http://creativecommons.org/licenses/by-sa/4.0/}.
#'
#' @note Temperatures in \code{GSODRdata} are in degrees C, in the original
#' WorldClim data they are in degrees C * 10.
#'
#' @references Hijmans, R.J., S.E. Cameron, J.L. Parra, P.G. Jones and A.
#' Jarvis, 2005. Very high resolution interpolated climate surfaces for global
#' land areas. International Journal of Climatology 25: 1965-1978.
"WorldClim_Bio"
