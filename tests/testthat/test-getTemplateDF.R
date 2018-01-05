context("getTemplateDF functions")

test_that("getSingleTemplate", {
  actual <- Import2ImmPort:::getSingleTemplate("study_pubmed")
  expected <- ImmPortTemplates[ImmPortTemplates$templateName == "study_pubmed", ]

  expect_equal(actual, expected)
})

test_that("updateTypes", {
  columnType <- c("varchar(100)", NA, "clob", "integer", "float", "date")

  actual <- Import2ImmPort:::updateTypes(columnType)
  expected <- c("character", "logical", "character", "double", "double", "character")

  expect_equal(actual, expected)
})

test_that("getTemplateDF", {
  actual <- getTemplateDF("planned_visit")
  expected <- data.frame("User Defined ID" = "",
                         "Name" = "",
                         "Order Number" = NA_real_,
                         "Min Start Day" = NA_real_,
                         "Max Start Day" = NA_real_,
                         "Start Rule" = "",
                         "End Rule" = "",
                         check.names = FALSE,
                         stringsAsFactors = FALSE)

  expect_equal(actual, expected)
})
