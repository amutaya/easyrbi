context("test_trends")
library(testthat)
library(easyrbi)
library(tidyr)
library(lubridate)

# sitedata
expect_equal(ncol(sitedata(c("01564500", "01567000"), "1970-10-01", "1980-09-30")), 18)
expect_error(sitedata("01564500", "1970-10-01"),  "is missing, with no default")
expect_s3_class((sitedata("01567000", "1970-10-01", "1980-09-30")$Date), "Date", exact = FALSE)

# rbi_df
expect_true(rbi_df("01567000", "1970-10-01", "1980-09-30")[1,2] <=1)
expect_equal(nchar(colnames(rbi_df("01567000", "1970-10-01", "1980-09-30"))[2]), 8)
expect_true(nchar(rbi_df("01567000", "1970-10-01", "1980-09-30")[2,1]) == 4)
