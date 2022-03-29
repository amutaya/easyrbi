rbiWy_dfAll <-
  "https://docs.google.com/spreadsheets/d/e/2PACX-1vSMoc3ICoJarNy8yvsDt3M8voFPLr0jDkORQ4g1e59GnsRiOEpKnMKEyRBsN-nLzT40QXj9ZSiW5dkz/pub?gid=441939603&single=true&output=csv" %>%
  read_csv()
usethis::use_data(rbiWy_dfAll, overwrite = TRUE)

all_sites <- as.data.frame(colnames(rbiWy_dfAll)) %>%
  rename(site_no = `colnames(rbiWy_dfAll)`) %>%
  filter(!site_no == "waterYear")
usethis::use_data(all_sites, internal = TRUE)
