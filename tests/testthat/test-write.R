context("write functions")

test_that("write_header", {
  name <- "basic_study_design"
  file <- tempfile()
  R2i:::write_header(name, file)

  actual <- readLines(file)
  expected <- c(
    "basic_study_design\tSchema Version 3.18",
    "Please do not delete or edit this column"
  )

  expect_equal(actual, expected)
})

test_that("write_line", {
  file <- tempfile()

  R2i:::write_line(file)

  actual <- readLines(file)
  expected <- c(
    ""
  )

  expect_equal(actual, expected)
})

test_that("write_blockName", {
  blockName <- "study"
  file <- tempfile()

  R2i:::write_blockName(blockName, file)

  actual <- readLines(file)
  expected <- c(
    "study"
  )

  expect_equal(actual, expected)
})

test_that("write_table", {
  table <- data.frame(
    "User Defined ID" = c(
      "example human study.Question 1",
      "example human study.Question 2"
    ),
    "Criterion" = c(
      "Question asked",
      "Question asked"
    ),
    "Criterion Category" = c(
      "Inclusion",
      "Exclusion"
    ),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )
  file <- tempfile()

  R2i:::write_table(table, file)

  actual <- readLines(file)
  expected <- c(
    "Column Name\tUser Defined ID\tCriterion\tCriterion Category",
    "\texample human study.Question 1\tQuestion asked\tInclusion",
    "\texample human study.Question 2\tQuestion asked\tExclusion"
  )

  expect_equal(actual, expected)
})

test_that("write_list", {
  list <- list(
    "User Defined ID" = "example human study",
    "Brief Title" = "example human study title",
    "Official Title" = "example human study official"
  )
  file <- tempfile()

  R2i:::write_list(list, file)

  actual <- readLines(file)
  expected <- c(
    "User Defined ID\texample human study",
    "Brief Title\texample human study title",
    "Official Title\texample human study official"
  )

  expect_equal(actual, expected)
})

test_that("write_emptyTable", {
  varNames <- c(
    "File Name",
    "Description",
    "Study File Type"
  )
  file <- tempfile()

  R2i:::write_emptyTable(varNames, file)

  actual <- readLines(file)
  expected <- c(
    "\tFile Name\tDescription\tStudy File Type"
  )

  expect_equal(actual, expected)
})

test_that("write_txt", {
  name <- "basic_study_design"
  file <- tempfile()

  R2i:::write_txt(name, demoData, file) # demoData comes from data-raw/demoData.R

  actual <- readLines(file)
  expected <- readLines("basic_study_design.txt")

  expect_equal(actual, expected)
})
