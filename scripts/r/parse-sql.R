reticulate::use_virtualenv("~/.virtualenvs/etl-make", required = TRUE)

resource_name <- commandArgs(trailingOnly = TRUE)

sql_query <- dtamg::parse_sql("datapackage.json", gsub("-", "_", resource_name))
writeLines(sql_query, glue::glue("scripts/sql/{resource_name}.sql"))
