context("test_trends")
library(testthat)
library(easyrbi)
library(tidyr)

rbiWy_df <- rbiWy_dfAll %>%
  pivot_wider(names_from = "site_no", values_from = rbi)


# trends
expect_equal(ncol(trends(rbiWy_df)), 15)
expect_true(all(trends(rbiWy_df)$p.value <= 1))
expect_type(trends(rbiWy_df)$conf.int1, "double")






