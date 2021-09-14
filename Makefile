.PHONY: help extract

RESOURCES=$(shell cat datapackage.json | jq -r ' .resources | .[] | .name ')

LOAD_FILES=$(subst csv.gz,txt, $(subst data,logs/loading, $(DATA_FILES)))

VALIDATION_REPORTS=$(patsubst %, logs/validation/%.json, $(RESOURCES))

DATA_FILES=$(shell cat datapackage.json | jq -r ' .resources | .[] | .path ')

DATA_STAGING_FILES=$(subst csv.gz,csv, $(subst data,data/staging, $(DATA_FILES))) 

DATA_RAW_FILES := $(patsubst %, data-raw/%.csv, $(RESOURCES))

SQL_FILES := $(patsubst %, scripts/sql/%.sql, $(RESOURCES))

#====================================================================

# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

extract: $(DATA_STAGING_FILES) ## Extract files
	rsync --checksum data/staging/* data/raw/ # rsync --checksum --dry-run --out-format='%n' data-raw/* data/
	python scripts/python/update-resources-checksum.py

full-extract: 
	python scripts/python/full-extract.py
	rsync --checksum data/staging/* data/raw/ # rsync --checksum --dry-run --out-format='%n' data-raw/* data/
	python scripts/python/update-resources-checksum.py

data/%.csv.gz: data/raw/%.csv
	gzip -n < data/raw/$*.csv > data/$*.csv.gz

validate: $(VALIDATION_REPORTS)
	
$(DATA_STAGING_FILES): data/staging/%.csv: scripts/python/extract-resource.py scripts/sql/%.sql
	python $< $* 2> logs/extraction/$*.txt
#	
# 	python scripts/python/transform.py $*
# 	rm data-raw/*

$(VALIDATION_REPORTS): logs/validation/%.json: scripts/python/validate.py data/%.csv.gz schemas/%.yaml
	python $< $* > $@

load: $(LOAD_FILES)

$(LOAD_FILES): logs/loading/%.txt: scripts/python/load-resource.py
	python $< $* > $@

parse: $(SQL_FILES)

$(SQL_FILES): scripts/sql/%.sql: scripts/r/parse-sql.R schemas/%.yaml
	Rscript --verbose $< $* 2> logs/sql/$*.Rout

vars: 
	@echo 'VALIDATION_REPORTS:' $(VALIDATION_REPORTS)
