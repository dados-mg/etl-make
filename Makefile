.PHONY: help vars parse extract full-extract ingest validate notify load all

include config.mk

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

all: parse extract ingest validate notify

datapackage.json: scripts/python/build-datapackage.py datapackage.yaml schemas/* data/* logs/validate/* dialect.json README.md CHANGELOG.md CONTRIBUTING.md
	python $<

parse: $(SQL_FILES)

$(SQL_FILES): scripts/sql/%.sql: scripts/r/parse-sql.R schemas/%.yaml
	Rscript --verbose $< $* 2> logs/parse/$*.Rout

full-extract: 
	python scripts/python/full-extract.py

extract: $(DATA_RAW_FILES) ## Extract raw files from external source into data/raw/

$(DATA_RAW_FILES): data/raw/%.csv: scripts/python/extract-resource.py scripts/sql/%.sql
	python $< $* 2> logs/extract/$*.txt

ingest: $(DATA_INGEST_FILES) ## Ingest raw files (data/raw/) into staging area (data/staging/)

$(DATA_INGEST_FILES): data/staging/%.csv: data/raw/%.csv
	rsync --checksum data/raw/* data/staging/

data/%.csv.gz: data/staging/%.csv ## Compress staged files (data/staging/) to data/
	gzip -n < data/staging/$*.csv > data/$*.csv.gz

validate: $(VALIDATION_FILES)
	
notify:
	python scripts/python/mail_sender.py

$(VALIDATION_FILES): logs/validate/%.json: scripts/python/validate.py data/%.csv.gz schemas/%.yaml
	python $< $* > $@

load: 
	dpckan dataset update

$(LOAD_FILES): logs/load/%.txt: scripts/python/load-resource.py logs/validate/%.json
	python $< $* > $@

vars: 
	@echo 'DATA_FILES:' $(DATA_FILES)

