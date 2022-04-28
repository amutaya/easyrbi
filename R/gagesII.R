#' Retrieve dam removal data for specified sites directly from the USGS Gages II website. This time series data recorded between 1931-01-01 and 2014-12-31
#'dam_removal
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

#' Retrieve dam removal and hydrology data from the USGS and USGS Gages II websites for given sites over a specified period. The dataframe contains calculated RBI summary statistics and dam removal time series data recorded between 1931-01-01 and 2014-12-31.
#' dam_trends
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

  dam_trends_df <- trends(rbi_data) %>%
    left_join(dam_removal(site_num), by = c("site_no"= "STAID"))
  return(dam_trends_df)
}

