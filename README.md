
### easyrbi R Package

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/SDS270)](https://CRAN.R-project.org/package=SDS270)
[![R-CMD-check](https://github.com/wndlovu/easyrbi/workflows/R-CMD-check/badge.svg)](https://github.com/wndlovu/easyrbi/actions)
<!-- badges: end -->

## Overview

The [`easyrbi`](https://github.com/amutaya/easyrbi) R package consists
of functions and datasets that can be used to calculate Richards-Baker
Flashiness Index (RBI) trends over time for 301 sites. The main
functions are:

1.  The sitedata() function retrieves hydrology data for given USGS
    gauge sites for a specified period.
2.  rbi\_df() returns calculated RBI values for given USGS sites for a
    specified period.
3.  The trends() function has the ability to return a data frame
    containing Mann-Kendall and sens.slope summary statistics for a
    custom number of sites specified by the user.
4.  dam\_removal() retrieves dam removal data from the USGS Gages II
    website for any number of given gauge station numbers.

## Installation

You can install the development version of easyrbi from Github:

``` r
# If you haven't installed remotes yet, do so:
# install.packages("remotes")
remotes::install_github("amutaya/easyrbi")
```

## Example

``` r
library(easyrbi)
library(tidyverse)
library(trend)
library(Kendall)
library(dataRetrieval)
library(usethis)
```

1.  This returns a data.frames with 18 variables from the USGS database
    which include discharge, drainage area and waterYear

``` r
sitedata(c("01564500", "01567000"), "1970-10-01", "1980-09-30") %>% 
  head(10)
#>          Date  site_no                            station_nm lat_va long_va
#> 1  1970-10-01 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 2  1970-10-02 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 3  1970-10-03 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 4  1970-10-04 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 5  1970-10-05 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 6  1970-10-06 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 7  1970-10-07 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 8  1970-10-08 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 9  1970-10-09 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#> 10 1970-10-10 01564500 Aughwick Creek near Three Springs, PA 401245  775532
#>    dec_lat_va dec_long_va coord_datum_cd dec_coord_datum_cd district_cd
#> 1    40.21258   -77.92528          NAD27              NAD83          42
#> 2    40.21258   -77.92528          NAD27              NAD83          42
#> 3    40.21258   -77.92528          NAD27              NAD83          42
#> 4    40.21258   -77.92528          NAD27              NAD83          42
#> 5    40.21258   -77.92528          NAD27              NAD83          42
#> 6    40.21258   -77.92528          NAD27              NAD83          42
#> 7    40.21258   -77.92528          NAD27              NAD83          42
#> 8    40.21258   -77.92528          NAD27              NAD83          42
#> 9    40.21258   -77.92528          NAD27              NAD83          42
#> 10   40.21258   -77.92528          NAD27              NAD83          42
#>    state_cd county_cd country_cd alt_va drain_area_va X_00060_00003     mm_day
#> 1        42       061         US 618.65           205            37 0.17049387
#> 2        42       061         US 618.65           205            31 0.14284621
#> 3        42       061         US 618.65           205            30 0.13823827
#> 4        42       061         US 618.65           205            29 0.13363033
#> 5        42       061         US 618.65           205            26 0.11980650
#> 6        42       061         US 618.65           205            21 0.09676679
#> 7        42       061         US 618.65           205            19 0.08755090
#> 8        42       061         US 618.65           205            17 0.07833502
#> 9        42       061         US 618.65           205            18 0.08294296
#> 10       42       061         US 618.65           205            17 0.07833502
#>    waterYear
#> 1       1971
#> 2       1971
#> 3       1971
#> 4       1971
#> 5       1971
#> 6       1971
#> 7       1971
#> 8       1971
#> 9       1971
#> 10      1971
```

2.  This returns a data.frames with 20 variables from the USGS database
    which include discharge, drainage area, waterYear and the RBI value

``` r
rbi_df(c("01564500", "01567000"), "1970-10-01", "1980-09-30")
#> # A tibble: 10 × 3
#>    waterYear `01564500` `01567000`
#>        <dbl>      <dbl>      <dbl>
#>  1      1971      0.379      0.181
#>  2      1972      0.467      0.255
#>  3      1973      0.402      0.170
#>  4      1974      0.409      0.168
#>  5      1975      0.480      0.219
#>  6      1976      0.398      0.161
#>  7      1977      0.424      0.218
#>  8      1978      0.396      0.186
#>  9      1979      0.378      0.223
#> 10      1980      0.379      0.208
```

3.  This returns the Mann-Kendall and sens.slope summary statistics for
    any given USGS gauge sites.

``` r
data <- rbi_df(c("01564500", "01567000"), "1970-10-01", "1980-09-30")

trends(x = data) 
#>    site_no         tau        sl   S  D varS estimates.Sen's slope statistic.z
#> 1 01564500 -0.28888890 0.2831308 -13 45  125         -0.0038942433  -1.0733126
#> 2 01567000  0.06666667 0.8580277   3 45  125          0.0008869355   0.1788854
#>     p.value null.value.z alternative      method parameter.n    conf.int1
#> 1 0.2831309            0   two.sided Sen's slope          10 -0.014949082
#> 2 0.8580277            0   two.sided Sen's slope          10 -0.005355905
#>     conf.int2
#> 1 0.004216093
#> 2 0.010844155
```

4.  Retrieve dam removal data for specified sites directly from the USGS
    Gages II website. This time series data recorded between 1931-01-01
    and 2014-12-31.

``` r
dam_removal(c("01564500", "01567000"))
#> Downloaded: 0.02 MB  (71%)Downloaded: 0.02 MB  (71%)Downloaded: 0.02 MB  (100%)Downloaded: 0.02 MB  (100%)Downloaded: 0.02 MB  (100%)Downloaded: 0.02 MB  (100%)
#> # A tibble: 3 × 7
#>   STAID    YearDamRemoved Dam_Latitude Dam_Longitude Location  River_Basin State
#>   <chr>             <int>        <dbl>         <dbl> <chr>     <chr>       <chr>
#> 1 01567000           2004         40.7         -77.6 "Burnham" Tea Creek   PA   
#> 2 01567000           2006         40.6         -77.7 "Lewisto… Strodes Run PA   
#> 3 01567000           2011         40.7         -78.2 ""        Tributary … PA
```
