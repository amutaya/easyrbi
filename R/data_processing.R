#' Retrieve hydrology data from the USGS website for given sites and duration
#'
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
  site_values <- dataRetrieval::readNWISdv(site_num, "00060",startDate, endDate) %>% # specify the parameter
    left_join(dataRetrieval::readNWISsite(site_num), by = c("site_no" = "site_no")) %>% # get site area, lat, long etc
    select(Date, site_no, station_nm, lat_va, long_va, dec_lat_va, dec_long_va, coord_datum_cd,
           dec_coord_datum_cd, district_cd, state_cd, county_cd, country_cd, alt_va,
           drain_area_va, X_00060_00003) %>%
    mutate(mm_day = ((((X_00060_00003/147197940448.88)*86400)/drain_area_va))*(1609.344*1000),
           waterYear = as.numeric(format(as.Date(Date) + lubridate::days(92), "%Y"))) # add waterYear
  return(site_values)
}


#' Calculate the Richard Baker Index (RBI) for given sites
#' rbi
#'
#' @param q a dataframe containing the daily discharge data.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import dataRetrieval


rbi <- function(q){
  qdiff <- tibble(q, c(0, diff(mm_day))) %>%
    dplyr::rename(qdiff_val = `c(0, diff(mm_day))`) %>%
    mutate(rbi_values = (sum(abs(qdiff_val))/sum(mm_day))) # and calculate rbi for each year number (sum of changes
  #in daily discharge/sum of daily discharge)
}

#' Add calculated RBI value to the data.frame
#' rbi_df
#'
#' @param site_num a "character" vector that contains the study site numbers.
#' @param startDate a "date" following the Y-m-d format.
#' @param endDate a "date" following the Y-m-d format.
#' @return returns a data.frame with the waterYear variable and RBI values for specified sites saved in columns.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @importFrom purrr map
#' @import dataRetrieval
#'
#' @examples
#' # return a dataframe with annual RBI values for specified USGS gauge sites over specified duration
#' library(easyrbi)
#' rbi_df(c("01564500", "01567000"), "1970-10-01", "1980-09-30")


rbi_df <- function(site_num, startDate, endDate){
  site_values <- data.frame()
  all_site_values <- rbind(site_values, sitedata(site_num, startDate, endDate)) %>%
    group_by(site_no, waterYear) %>%
    nest() %>%
    summarise(site_no = site_no,
              waterYear = waterYear,
              rbi_vals = map(data, rbi)) %>%
    unnest(rbi_vals) %>%
    distinct(site_no, waterYear, rbi_values) %>%
    pivot_wider(names_from = site_no, values_from = rbi_values)
  return(all_site_values)
}
