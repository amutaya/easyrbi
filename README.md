
### easyrbi R Package

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/SDS270)](https://CRAN.R-project.org/package=SDS270)
<!-- badges: end -->

## Overview

The [`easyrbi`](https://github.com/amutaya/easyrbi) R package consists
of functions and datasets that can be used to calculate Richards-Baker
Flashiness Index (RBI) trends over time for 301 sites. The main
functions are:

1.  The trendAnalysis() function perform the MannKendall and sens.slope
    analysis on a data frame with annual Richards-Baker Flashiness Index
    (RBI) values.
2.  The trends() function then maps these summary statistics into a one
    data frame, adds an additional column with the site numbers and
    removes the summary statistics row for the year variable. The
    trends() function has the ability to return a data frame containing
    of length 301 which summary statistics for all 301 sites or a custom
    number of sites specified by the user.

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
library(dplyr)
```

1.  This returns a character vector with 15 observations that include
    summary statistics from the Mann-Kendall and sens.slope analysis.

``` r
df <- data.frame (year  = seq(from = 2010, to = 2020, by = 1),
site_num = seq(from = 1, to= 2, by = .1))

trendAnalysis(df$site_num)
#>                    tau                     sl                      S 
#>     "1.00000011920929" "2.62260437011719e-05"                   "55" 
#>                      D                   varS  estimates.Sen's slope 
#>     "54.9999961853027"                  "165"                  "0.1" 
#>            statistic.z                p.value           null.value.z 
#>     "4.20389429847222" "2.62361493945871e-05"                    "0" 
#>            alternative              data.name                 method 
#>            "two.sided"                    "x"          "Sen's slope" 
#>            parameter.n              conf.int1              conf.int2 
#>                   "11"                  "0.1"                  "0.1"
```

2.  This returns summary statistics for all USGS sites given in the
    rbiWy\_dfAll dataframe.

``` r
trends() %>% 
  head()
#> Rows: 50 Columns: 302
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (302): waterYear, 1011000, 1013500, 1017000, 1019000, 1022500, 1030500, ...
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#>   site_no         tau         sl    S    D     varS estimates.Sen's slope
#> 1 1011000  0.10367347 0.29189563  127 1225 14291.67          1.479563e-04
#> 2 1013500  0.09877551 0.31548333  121 1225 14291.67          6.057078e-05
#> 3 1017000  0.15918367 0.10463595  195 1225 14291.67          2.670132e-04
#> 4 1019000 -0.16734694 0.08792788 -205 1225 14291.67         -2.885680e-04
#> 5 1022500  0.24571429 0.01209164  301 1225 14291.67          6.803685e-04
#> 6 1030500  0.20816326 0.03361380  255 1225 14291.67          3.038356e-04
#>   statistic.z    p.value null.value.z alternative      method parameter.n
#> 1    1.053972 0.29189570            0   two.sided Sen's slope          50
#> 2    1.003783 0.31548325            0   two.sided Sen's slope          50
#> 3    1.622782 0.10463593            0   two.sided Sen's slope          50
#> 4   -1.706431 0.08792787            0   two.sided Sen's slope          50
#> 5    2.509457 0.01209168            0   two.sided Sen's slope          50
#> 6    2.124674 0.03361383            0   two.sided Sen's slope          50
#>       conf.int1    conf.int2
#> 1 -1.667483e-04 4.641122e-04
#> 2 -8.311187e-05 2.146143e-04
#> 3 -8.930073e-05 7.162620e-04
#> 4 -6.506636e-04 6.861917e-05
#> 5  1.868684e-04 1.201730e-03
#> 6  2.661966e-05 5.654226e-04
```

3.  This returns summary statistics for given USGS sites that are in the
    rbiWy\_dfAll dataframe.

``` r
trends(site = c("01011000", "01042500"))
#> Rows: 50 Columns: 302
#> ── Column specification ────────────────────────────────────────────────────────
#> Delimiter: ","
#> dbl (302): waterYear, 1011000, 1013500, 1017000, 1019000, 1022500, 1030500, ...
#> 
#> ℹ Use `spec()` to retrieve the full column specification for this data.
#> ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
#>  [1] site_no               tau                   sl                   
#>  [4] S                     D                     varS                 
#>  [7] estimates.Sen's slope statistic.z           p.value              
#> [10] null.value.z          alternative           method               
#> [13] parameter.n           conf.int1             conf.int2            
#> <0 rows> (or 0-length row.names)
```
