context("test_dam_removal")
library(testthat)
library(easyrbi)
library(tidyr)
library(usethis)
library(utils)

#dam_removal
expect_true(nchar(dam_removal("01567000")[2,1]) >= 8)
expect_type((dam_removal("01567000")$State), "character")

#dam_trends
expect_equal(ncol(dam_trends("01567000", "1970-10-01", "1990-09-30")), 21)


# basinID
#expect_error(nchar(basin_id("0120850")$STAID), "Invalid site number")
expect_type((basin_id("01567000")$STATE), "character")
