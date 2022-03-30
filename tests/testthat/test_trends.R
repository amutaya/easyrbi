context("test_trends")
library(testthat)
library(easyrbi)
library(tidyr)


all_sites <- as.data.frame(colnames(rbiWy_dfAll)) %>%
  dplyr::rename(site_no = `colnames(rbiWy_dfAll)`) %>%
  filter(!site_no == "waterYear")

all(trends(site = all_sites$site_no)$p.value) <= 1
class(trends(site = all_sites$site_no)$conf.int1) == "numeric"
ncol(trends(site = all_sites$site_no)) == 15
nrow(trends(site = all_sites$site_no)) == 301

