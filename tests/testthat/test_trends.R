context("test_trends")
library(testthat)
library(easyrbi)
library(tidyr)

rbiWy_dfAll <-
  "https://docs.google.com/spreadsheets/d/e/2PACX-1vSMoc3ICoJarNy8yvsDt3M8voFPLr0jDkORQ4g1e59GnsRiOEpKnMKEyRBsN-nLzT40QXj9ZSiW5dkz/pub?gid=441939603&single=true&output=csv" %>%
  readr::read_csv()
all_sites <- as.data.frame(colnames(rbiWy_dfAll)) %>%
  dplyr::rename(site_no = `colnames(rbiWy_dfAll)`) %>%
  filter(!site_no == "waterYear")

all(trends(site = all_sites$site_no)$p.value) <= 1
class(trends(site = all_sites$site_no)$conf.int1) == "numeric"
ncol(trends(site = all_sites$site_no)) == 15
nrow(trends(site = all_sites$site_no)) == 301

