context("test_dam_removal")
library(testthat)
library(easyrbi)
library(tidyr)
library(usethis)
library(utils)

expect_true(nchar(dam_removal("01567000")[2,1]) == 8)
#expect_type((dam_removal("01567000")$State), "character")
