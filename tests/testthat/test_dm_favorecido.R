context("dm_favorecido")

dt <- fread("~/Projects/cge_age7/data/dm_favorecido.csv.gz")

anos <- 2002:2021

id_favorecido_lemg <- map(anos, get_id_favorecido_lemg)

get_id_favorecido_lemg <- function(x) {
  path_ft_despesa <- glue::glue("~/Projects/cge_age7/data/ft_despesa_{x}.csv.gz")
  path_ft_restos_pagar <- glue::glue("~/Projects/cge_age7/data/ft_restos_pagar_{x}.csv.gz")
  dm_unidade_orc <- fread("~/Projects/cge_age7/data/dm_unidade_orc.csv.gz")
  
  ft_despesa <- fread(path_ft_despesa)[id_elemento == 494 & id_item == 2878]
  id_favorecido_despesa <- dm_unidade_orc[ft_despesa, on = "id_unidade_orc"][cd_unidade_orc == 2041, id_favorecido]
  
  ft_restos_pagar <- fread(path_ft_restos_pagar)[id_elemento == 494 & id_item == 2878]
  id_favorecido_restos_pagar <- dm_unidade_orc[ft_despesa, on = "id_unidade_orc"][cd_unidade_orc == 2041, id_favorecido]
  
  unique(c(id_favorecido_despesa, id_favorecido_restos_pagar))
}


ft_despesa_2020[id_empenho == 1871947]
ft_restos_pagar[id_empenho == 1871947] |> dplyr::select(id_empenho, 
                                                        cd_evento,
                                                        cd_documento,
                                                        dt_documento,
                                                        vr_nao_processado)
dm_empenho_resto[id_empenho == 1871947] |> dplyr::select(id_empenho,
                                                         nr_empenho,
                                                         dt_empenho,
                                                         dt_original,
                                                         tipo_empenho,
                                                         item_desp,
                                                         razao_social_credor,
                                                         vr_empenho) |> t()
dm_empenho_desp[nr_empenho == 67 & 
                grepl("2041.+", unidade_orcamentaria)] |> 
                dplyr::select(id_empenho, ano_exercicio)

test_that("", {
  
  rules <- validate::validator()
  report <- validate::confront(dt, rules)
  
  expect_false(summary(report)[["error"]]) 
  expect_equal(summary(report)[["fails"]], expected = 0)
  
})