context("checkTemplate functions")

test_that("checkClass", {
  # success case
  expect_null(
    Import2ImmPort:::checkClass(
      df = data.frame(),
      dfName = "a data.frame"
    )
  )

  # fail case
  expect_error(
    Import2ImmPort:::checkClass(
      df = list(),
      dfName = "a list"
    )
  )
})

test_that("checkDim", {
  # success cases
  expect_null(
    Import2ImmPort:::checkDim(
      df = data.frame(1, 2, 3),
      templateInfo = data.frame(1:3),
      ImmPortTemplateName = "case #1"
    )
  )
  expect_null(
    Import2ImmPort:::checkDim(
      df = data.frame(1),
      templateInfo = data.frame(1),
      ImmPortTemplateName = "case #2"
    )
  )

  # fail cases
  expect_error(
    Import2ImmPort:::checkDim(
      df = data.frame(1, 2, 3),
      templateInfo = data.frame(1:2),
      ImmPortTemplateName = "case #3"
    )
  )
  expect_error(
    Import2ImmPort:::checkDim(
      df = data.frame(1, 2),
      templateInfo = data.frame(1:3),
      ImmPortTemplateName = "case #4"
    )
  )
})

test_that("checkColnames", {
  # success case
  expect_null(
    Import2ImmPort:::checkColnames(
      df = data.frame(x = 1, y = 2, z = 3),
      templateInfo = data.frame(templateColumn = c("x", "y", "z"),
                                stringsAsFactors = FALSE),
      ImmPortTemplateName = "case #1"
    )
  )

  # fail case
  expect_error(Import2ImmPort:::checkColnames(data.frame(x = 1, y = 2, z = 3),
                                              data.frame(templateColumn = c("x", "y", "w"),
                                                         stringsAsFactors = FALSE),
                                              "case #2"))
})

test_that("checkTypes", {
  # success case
  expect_null(
    Import2ImmPort:::checkTypes(
      df = data.frame("", "", NA_character_, NA_real_, 0,
                      stringsAsFactors = FALSE),
      templateInfo = data.frame(jsonDataType = c("string", "date", "enum", "number", "positive"),
                                stringsAsFactors = FALSE),
      ImmPortTemplateName = "case #1"
    )
  )

  # fail case
  expect_error(
    Import2ImmPort:::checkTypes(
      df = data.frame(1, "", "", 0, 0,
                      stringsAsFactors = FALSE),
      templateInfo = data.frame(jsonDataType = c("string", "date", "enum", "number", "positive"),
                                stringsAsFactors = FALSE),
      ImmPortTemplateName = "case #2"
    )
  )
})

test_that("checkRequired", {
  # success case
  expect_null(
    Import2ImmPort:::checkRequired(
      df = data.frame(a = "a", b = "b", c = "", d = 1, e = NA_real_,
                      stringsAsFactors = FALSE),
      templateInfo = data.frame(templateColumn = c("a", "b", "c", "d", "e"),
                                required = c(TRUE, TRUE, FALSE, TRUE, FALSE),
                                stringsAsFactors = FALSE),
      ImmPortTemplateName = "case #1"
    )
  )

  # fail case
  expect_error(
    Import2ImmPort:::checkRequired(
      df = data.frame(a = "a", b = "b", c = "", d = 1, e = NA_real_,
                      stringsAsFactors = FALSE),
      templateInfo = data.frame(templateColumn = c("a", "b", "c", "d", "e"),
                                required = c(TRUE, TRUE, TRUE, TRUE, TRUE),
                                stringsAsFactors = FALSE),
      ImmPortTemplateName = "case #1"
    )
  )
})

# test_that("compareValues", {
#
# })
#
# test_that("checkFormat", {
#
# })
#
# test_that("checkTemplate", {
#
# })
