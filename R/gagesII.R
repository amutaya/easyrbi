#' Retrieve dam removal time series data from the USGS Gages II website.
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @return returns a data frame with 7 variables which includes the year when the dam was removed and the site location.
#' @export
#'
#' @import usethis
#' @import dplyr
#' @import tidyr
#' @importFrom utils read.table
#'
#' @examples
#' # returns a dataframe with the dam removals for specified sites.
#' library(easyrbi)
#' dam_removal("01034500")

dam_removal <- function(site_num){
  dam_url <- "https://www.sciencebase.gov/catalog/file/get/59692a64e4b0d1f9f05fbd39?f=__disk__c9%2F40%2Ff2%2Fc940f2f914e04b26bf0e81d81c9f273113f7a5c8"
  dam_data <- use_zip(
    dam_url,
    destdir = getwd(),
    cleanup = if (rlang::is_interactive()) NA else FALSE

  )

  dams <- read.table("Dataset3_DamRemovals/DamRemovals.txt",sep=",",header=T) %>%
    mutate(STAID = as.character(paste0("0", STAID))) %>%
    filter(STAID == site_num) %>%
    as_tibble()
  return(dams)
}

#' Create a dataframe containing dam removal and hydrology data from the USGS and USGS GAGES II websites.
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @param startDate a "date" following the Y-m-d format.
#' @param endDate a "date" following the Y-m-d format.
#' @return returns a dataframe with 21 variables which include the dams removed and corresponding summary statistics from the sens.Slope and Kendall analysis.
#' @export
#'
#' @example
#' # returns RBI summary statistics and dam removal data for given sites over the specified period
#' library(easyrbi)
#' dam_trends("01567000", "1970-10-01", "1990-09-30")
#'
dam_trends <- function(site_num, startDate, endDate){
  rbi_data <- rbi_df(site_num, startDate, endDate)

  dam_trends_df <- dam_removal(site_num) %>%
    right_join(trends(rbi_data), by = c("STAID"= "site_no"))
  return(dam_trends_df)
}

#' Retrieve site classification (Reference and Non-reference sites) from USGS GAGES II website.
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @return returns a data frame with 10 variables which includes the drainage area and site classification
#' @export
#'
#' @example
#' returns the basin ID data for specified sites
#' library(easyrbi)
#' basin_id(c("01567000", "01490000", "01492500"))
#'
basin_id <- function(site_num){
  if (nchar(site_num) < 8){
    stop("Invalid site number")
  } else{


  basin_url <- "https://www.sciencebase.gov/catalog/file/get/59692a64e4b0d1f9f05fbd39?f=__disk__3b%2F5c%2F06%2F3b5c0605384344f93b61c00fccf1a304b96019e3"
  basin_data <- use_zip(
    basin_url,
    destdir = getwd()

  )

  basins <- read.table("Dataset1_BasinID/BasinID.txt",sep=",",header=TRUE) %>%
    filter(STAID %in% c(site_num)) %>%
    as_tibble()
  return(basins)
  }
}

