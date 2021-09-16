.PHONY: help extract

RESOURCES = $(shell cat datapackage.json | jq -r ' .resources | .[] | .name ')

DATA_FILES = $(shell cat datapackage.json | jq -r ' .resources | .[] | .path ')

DATA_RAW_FILES = $(subst csv.gz,csv, $(subst data,data/raw, $(DATA_FILES)))

SQL_FILES = $(subst csv.gz,sql, $(subst data,scripts/sql, $(DATA_FILES)))

LOAD_FILES = $(subst csv.gz,txt, $(subst data,logs/load, $(DATA_FILES)))

VALIDATION_FILES = $(subst csv.gz,json, $(subst data,logs/validate, $(DATA_FILES)))

#====================================================================

# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

datapackage.json: scripts/python/build-datapackage.py datapackage.yaml parse extract ingest validate schemas/* data/* logs/validate/* dialect.json README.md CHANGELOG.md CONTRIBUTING.md
	python $<

parse: $(SQL_FILES)

$(SQL_FILES): scripts/sql/%.sql: scripts/r/parse-sql.R schemas/%.yaml
	Rscript --verbose $< $* 2> logs/parse/$*.Rout

full-extract: 
	python scripts/python/full-extract.py

extract: $(DATA_RAW_FILES) ## Extract files

$(DATA_RAW_FILES): data/raw/%.csv: scripts/python/extract-resource.py scripts/sql/%.sql
	python $< $* 2> logs/extract/$*.txt

ingest: ## Ingest raw files into staging area data/staging/
	rsync --checksum data/raw/* data/staging/ # 
	python scripts/python/update-resources-checksum.py

data/%.csv.gz: data/staging/%.csv
	gzip -n < data/staging/$*.csv > data/$*.csv.gz

validate: $(VALIDATION_FILES)
	
$(VALIDATION_FILES): logs/validate/%.json: scripts/python/validate.py data/%.csv.gz schemas/%.yaml
	python $< $* > $@

load: $(LOAD_FILES)

$(LOAD_FILES): logs/load/%.txt: scripts/python/load-resource.py logs/validate/%.json
	python $< $* > $@

notify: 


vars: 
	@echo 'VALIDATION_FILES:' $(VALIDATION_FILES)
