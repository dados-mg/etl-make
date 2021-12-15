context("Recurso ft_receita_v2018")

dt <- fread(here::here("data", "ft_receita_v2018.csv.gz"))

test_that("Unique foreign key", {

  rules <- validator(is_unique(id_unidade_orc))
  report <- confront(dt, rules)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})


test_that("Ano particao", {
  
  rules <- validator(unique(ano_particao) %in% c(2018, 2019, 2020, 2021))
  report <- confront(dt, rules)
  
  expect_equal(summary(report)[["fails"]], expected = 0)
})
