library(readr)

rbiWy_dfAll <- read_csv("data-raw/rbiWy_dfAll.csv")
usethis::use_data(rbiWy_dfAll, overwrite = TRUE)

all_sites <- as.data.frame(colnames(rbiWy_dfAll)) %>%
  rename(site_no = `colnames(rbiWy_dfAll)`) %>%
  filter(!site_no == "waterYear")
usethis::use_data(all_sites, internal = TRUE)
