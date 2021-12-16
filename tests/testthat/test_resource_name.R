context("resource_name")

dt <- data.table()

test_that("", {
  
  rules <- validate::validator()
  report <- validate::confront(dt, rules)
  
  expect_false(summary(report)[["error"]]) 
  expect_equal(summary(report)[["fails"]], expected = 0)
  
})