#' Calculate the sens.slope and MannKendall values for any time series
#'
#'
#' @param x a list of type spec_tbl_df/tbl_df/tbl/data.frame that has one column with consecutive times of class 'numeric'. The time variable can also be a 'Date' class.
#'
# #' @return a character vector with 15 observations
#' @export
#'
#' @importFrom Kendall MannKendall
#' @importFrom trend sens.slope
#'
#' @examples
#' # site_num is a numeric variable containing rbi values over consecutive years (year)
#'library(easyrbi)
#' df <- data.frame (year  = seq(from = 2010, to = 2020, by = 1),
#' site_num = seq(from = 1, to= 2, by = .1))
#'
#' trendAnalysis(df$site_num)
#'
#'
trendAnalysis <- function(x){
  mk <- MannKendall(x) # perform mann kendall analysis
  ss <- sens.slope(x) # perform sens.slope analysis
  df <- unlist(c(mk,ss), recursive = TRUE, use.names = TRUE) # create character vector
  return(df)
}



#' Create a dataframe containing summary statistics from the MannKendall and sens.slope analysis for set of USGS gauge stations over given duration.
#' trends
#'
#' @param x a data.frame containing the waterYear and RBI values for sites in one column.
#'
#' @return returns a list/data.frame with 15 variables calculated using trendAnalysis. The data.frame has 3 columns that are character vectors and 12 that are numeric.
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @importFrom readr read_csv
#' @importFrom purrr map_dfr
#' @examples
#' library(easyrbi)
#' library(dplyr)
#'
#' # return summary statistics for all USGS sites given in a dataframe containing annual RBI values
#' data <- rbi_df(c("01564500", "01567000"), "1970-10-01", "1980-09-30")
#' trends(x = data)


trends <- function(x){
  dataFile <- x
  trend_df <- map_dfr(dataFile, trendAnalysis) %>%
    select(-data.name) %>%
    cbind(as.data.frame(colnames(dataFile))) %>%
    rename(site_no = `colnames(dataFile)`) %>%
    filter(!site_no == "waterYear") %>%
    mutate_at(c(1:9, 12:14), as.numeric) %>%
    #filter(site_no %in% site) %>%
    select(site_no, tau:conf.int2)
  return(trend_df)
}



