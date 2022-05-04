
### easyrbi R Package <img src='data-raw/easyrbiHex.png' align="right" height="139"/>

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/wndlovu/easyrbi/workflows/R-CMD-check/badge.svg)](https://github.com/wndlovu/easyrbi/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/SDS270)](https://CRAN.R-project.org/package=SDS270)
<!-- badges: end -->

## Overview

The [`easyrbi`](https://github.com/amutaya/easyrbi) R package consists
of functions that retrieve streamflow data (pCode = 00060) from the
[USGS website](https://waterservices.usgs.gov/rest/Site-Test-Tool.html),
by using tools in the `dataRetrieval` package. Another set of functions
can be used to calculate the Richards-Baker Flashiness Index (RBI)
trends over time for any given gauge stations. The package also contains
functions to download time series land use data [USGS Gages
II](https://www.sciencebase.gov/catalog/item/59692a64e4b0d1f9f05fbd39)
collected between 1931-01-01 and 2014-12-31. Some of the functions
included in the package:

-   `sitedata`: retrieves hydrology data for given USGS gauge sites for
    a specified period.
-   `rbi_df`: returns calculated RBI values for given USGS sites for a
    specified period.
-   `trends`: returns a data frame containing Mann-Kendall and
    sens.slope summary statistics for a custom number of sites specified
    by the user.
-   `basin_id`: Check the drainage area, eco-region and classification
    (reference or non-reference)
-   `dam_removal`: retrieves dam removal data from the USGS Gages II
    website for any number of given gauge station numbers.

## Installation

You can install the development version of easyrbi from Github:

``` r
# If you haven't installed remotes yet, do so:
# install.packages("remotes")
remotes::install_github("amutaya/easyrbi")
```

## Examples

``` r
library(easyrbi)
library(tidyverse)
library(trend)
library(Kendall)
library(dataRetrieval)
library(usethis)
```

### Retrieve USGS gauge station data

#### Site data

-   Returns a data.frames with 18 variables from the USGS database which
    include discharge, drainage area and the waterYear.

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

#### Calculate the annul Richards Barker Flashiness Index (RBI)

-   Returns a data frame with the waterYear and respective RBI values
    for given sites over a specified time frame

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

#### Test time series trends

-   To test the flashiness trends over time, `trends` returns the
    Mann-Kendall and sens.slope summary statistics for any given USGS
    gauge sites.

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

### Basin classification and data

#### Watershed Identification

-   Retrieve site classification (Reference and Non-reference sites) and
    watershed area from USGS GAGES II.

``` r
basin_id(c("01567000", "01490000", "01492500"))
#> # A tibble: 3 × 10
#>   STAID    STANAME      DRAIN_SQKM HUC02 LAT_GAGE LNG_GAGE STATE HCDN.2009 CLASS
#>   <chr>    <chr>        <chr>      <chr> <chr>    <chr>    <chr> <chr>     <chr>
#> 1 01490000 CHICAMACOMI… 40.6       02    38.5116… -75.879… MD    ""        Ref  
#> 2 01492500 SALLIE HARR… 19.0       02    38.9648… -76.108… MD    ""        Ref  
#> 3 01567000 Juniata Riv… 8657.3     02    40.4784… -77.129… PA    ""        Non-…
#> # … with 1 more variable: AGGECOREGION <chr>
```

### Retrieve land use data

#### Dam removals

-   Retrieves dam removal data for specified sites directly from the
    USGS Gages II website. This time series data recorded between
    1931-01-01 and 2014-12-31.

``` r
dam_removal(c("01564500", "01567000"))
#> # A tibble: 3 × 7
#>   STAID    YearDamRemoved Dam_Latitude Dam_Longitude Location  River_Basin State
#>   <chr>             <int>        <dbl>         <dbl> <chr>     <chr>       <chr>
#> 1 01567000           2004         40.7         -77.6 "Burnham" Tea Creek   PA   
#> 2 01567000           2006         40.6         -77.7 "Lewisto… Strodes Run PA   
#> 3 01567000           2011         40.7         -78.2 ""        Tributary … PA
```

#### Dam removals and flashiness trends

-   To check if there is a relationship between trends and dam removals,
    `dam_trends` returns a dataframe with dam removals and trends
    statistics from the Mann-Kendall and sens.slope tests.

``` r
dam_trends(c("01092000", "01100000", "01208500"), "1970-10-01", "1990-09-30")
#> # A tibble: 7 × 21
#>   STAID    YearDamRemoved Dam_Latitude Dam_Longitude Location  River_Basin State
#>   <chr>             <int>        <dbl>         <dbl> <chr>     <chr>       <chr>
#> 1 01092000           2004         43.5         -71.5 Belmont   Tioga River NH   
#> 2 01092000           2010         43.1         -71.4 Hooksett  Browns Bro… NH   
#> 3 01100000           2008         42.9         -71.5 Merrimack Souhegan R… NH   
#> 4 01100000           2010         43.1         -71.4 Hooksett  Browns Bro… NH   
#> 5 01100000           2012         42.9         -71.5 Bedford   McQuade Br… NH   
#> 6 01208500           1999         41.5         -73.0 Naugatuck Naugatuck … CT   
#> 7 01208500           1999         41.6         -73.1 Waterbury Naugatuck … CT   
#> # … with 14 more variables: tau <dbl>, sl <dbl>, S <dbl>, D <dbl>, varS <dbl>,
#> #   `estimates.Sen's slope` <dbl>, statistic.z <dbl>, p.value <dbl>,
#> #   null.value.z <dbl>, alternative <chr>, method <chr>, parameter.n <dbl>,
#> #   conf.int1 <dbl>, conf.int2 <dbl>
```
