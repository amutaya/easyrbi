#' Available USGS sites data
#'
#' All the sites that are provided by the USGS. This dataset is
#' a subset of the rbi water year all sites dataset
#'
#' @format A data frame of 301 rows and one column representing the site
#' number of a particular site
#' \describe{
#'     \item{site_no}{The site number}
#' }
"all_sites"


#' Calculated RBI data for 301 sites USGS sites data
#'
#' RBI values are calculated for 301 USGS sites and stored in the dataframe. This data frame contains water year and annual RBI value for each site. Each column
#' from 01011000 to 01576500 contains RBI values for each site.
#'
#' @format A data frame of 50 rows and 301 columns.
#' \describe{
#'    \item{waterYear}{The water year}
#'    \item{01011000 - 01576500}{annual RBI values for the 301 study sites}
#' }
#' @ source hhh
"rbiWy_dfAll"
