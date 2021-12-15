context("Recurso dm_unidade_orc")

dt <- fread(here::here("data", "dm_unidade_orc.csv.gz"))

test_that("Unique primary key", {

  rules <- validator(is_unique(id_unidade_orc))
  report <- confront(dt, rules)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})
