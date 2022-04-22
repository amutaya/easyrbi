#' Retrieve hydrology from the USGS website for given sites and duration
#' sitedata
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @param startDate a "date" following the Y-m-d format.
#' @param endDate a "date" following the Y-m-d format.
#' @return returns a data.frame with 18 variables.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import dataRetrieval
#' @importFrom lubridate days
#'
#' @examples
#' # return stream hydrology data for given USGS sites
#' library(easyrbi)
#' sitedata(c("01564500", "01567000"), "1970-10-01", "1980-09-30")



sitedata <- function(site_num,startDate, endDate){
  site_values <<- dataRetrieval::readNWISdv(site_num, "00060",startDate, endDate) %>% # specify the parameter
    left_join(dataRetrieval::readNWISsite(site_num), by = c("site_no" = "site_no")) %>% # get site area, lat, long etc
    select(Date, site_no, station_nm, lat_va, long_va, dec_lat_va, dec_long_va, coord_datum_cd,
           dec_coord_datum_cd, district_cd, state_cd, county_cd, country_cd, alt_va,
           drain_area_va, X_00060_00003) %>%
    mutate(mm_day = ((((X_00060_00003/147197940448.88)*86400)/drain_area_va))*(1609.344*1000),
           waterYear = as.numeric(format(as.Date(Date) + lubridate::days(92), "%Y"))) # add waterYear
  return(site_values)
}


#' Calculate the Richard Baker Index (RBI) for given sites
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @param startDate a "date" following the Y-m-d format.
#' @param endDate a "date" following the Y-m-d format.
#' @param ... further arguments passed to or from other methods.
#' @return returns a data.frame with 20 variables.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import dataRetrieval
#'
#' @examples
#' # return stream hydrology data for given USGS sites with calculated RBI.
#' library(easyrbi)
#' rbi(c("01564500", "01567000"), "1970-10-01", "1980-09-30")


rbi <- function(site_num, startDate, endDate, ...){
  site_values <<- data.frame()
  all_site_values <<- rbind(site_values, sitedata(site_num, startDate, endDate))
  qdiff <<- tibble(all_site_values, c(0, diff(mm_day))) %>%
    dplyr::rename(qdiff_val = `c(0, diff(mm_day))`) %>%
    mutate(rbi_values = (sum(abs(qdiff_val))/sum(mm_day))) # and calculate rbi for each year number (sum of changes
  #in daily discharge/sum of daily discharge)
  return(qdiff)
}

rbi(c("01564500", "01567000", "01567500", "01568000"), startDate = "1970-10-01", endDate ="2020-09-30")

