context("Testes dm_empenho_desp_2021")

# dt[id_empenho == 12987751, razao_social_credor := "***.624.976-** - ALINE DE FATIMA MARQUES"]
# dt[id_empenho == 13012497, razao_social_credor := "000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO"]
# dt[id_empenho %in% c(12952580, 12952581, 12952864, 12953005, 12953140, 12953141, 
#                      12952730, 12960521, 12959428, 12959429, 12960178, 12959610, 12959801, 
#                      12959977, 12959978, 12960350, 12954854, 12957793, 12958520, 12959036, 
#                      12957095, 12957558, 12958341, 12969877, 12969878, 12969879, 13000020, 
#                      13026368, 13026369, 13026370, 12999610, 13026239, 13026602, 13026603, 
#                      13026604, 13026728, 13026729, 13026482, 13026483, 13026484, 13026485, 
#                      13026116, 13026117, 13026981, 13026982, 13026983, 13026984, 13026856, 
#                      13026854, 13026855, 12984282, 12983796, 12984617, 13001756, 13024357, 
#                      12986085, 12971318, 12971571, 12971197, 12970825, 12970826, 12970827, 
#                      12971436), razao_social_credor := "000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO"]

dt <- fread("~/Projects/cge_age7/data/dm_empenho_desp_2021.csv.gz")

ft_despesa <- dtamg::flatten_resource("~/Projects/cge_age7/datapackage.json", 
                                      "ft_despesa_2021",
                                      c("dm_empenho_desp_2021", "dm_unidade_orc", "dm_elemento_desp", "dm_item_desp", "dm_favorecido"))

# [, .(id_empenho, cd_unidade_orc, cd_elemento, cd_item, tp_documento)]

test_that("Anonimização prêmios lotéricos", {
  id_empenho_premios_lotericos <- ft_despesa[
    cd_unidade_orc == 2041 & cd_elemento == 31 & cd_item == 2 & tp_documento == 1,
    id_empenho
  ]
  
  dt[id_empenho %in% id_empenho_premios_lotericos, id_empenho_premios_lotericos := TRUE]
  
  rules <- validate::validator(if(id_empenho_premios_lotericos == TRUE) razao_social_credor == "000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO")
  report <- validate::confront(dt, rules)
  
  expect_false(summary(report)[["error"]]) 
  expect_equal(summary(report)[["fails"]], expected = 0)
})

test_that("Anonimização hanseniase", {
  
  # grepl("^761+", cd_uni_prog_gasto)
  rules <- validator(if(ano_exercicio >= 2021 & grepl("^4291.+", unidade_orcamentaria) & grepl("^1320007.+", unidade_executora) & grepl("^93.+", elemento_desp)) razao_social_credor == "000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO")
  report <- confront(dt, rules)  
  
  expect_false(summary(report)[["error"]]) 
  expect_equal(summary(report)[["fails"]], expected = 0)
})


test_that("Anonimização CPF", {
  
  id_empenho_desp_cpf <- ft_despesa[tp_documento == 1, id_empenho]  
  
  dt[id_empenho %in% id_empenho_desp_cpf, id_empenho_desp_cpf := TRUE]
  
  rules <- validator(if(id_empenho_desp_cpf == TRUE) grepl("\\*\\*\\*.\\d{3}.\\d{3}-\\*\\*.+|000.000.000-00 - INFORMACAO COM RESTRICAO DE ACESSO", razao_social_credor))
  report <- confront(dt, rules)  
  
  expect_false(summary(report)[["error"]]) 
  expect_equal(summary(report)[["fails"]], expected = 0)
})
