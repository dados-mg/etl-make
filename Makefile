.PHONY: help extract

RESOURCES=$(shell cat datapackage.json | jq -r ' .resources | .[] | .name ')

VALIDATION_REPORTS=$(patsubst %, logs/validation/%.json, $(RESOURCES))

DATA_RAW_FILES := $(patsubst %, data-raw/%.csv, $(RESOURCES))

SQL_FILES := $(patsubst %, scripts/sql/%.sql, $(RESOURCES))

#====================================================================

# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

datapackage.json: 

extract: $(DATA_RAW_FILES) ## Extract files

validate: $(VALIDATION_REPORTS)

# ls: 
# 	rsync --checksum --dry-run --out-format='%n' data-raw/* data/
# 
$(DATA_RAW_FILES): data-raw/%.csv: scripts/python/extract.py scripts/sql/%.sql
	python scripts/python/extract.py $* 2> logs/extraction/$*.txt
	gzip -n < $@ > data/$*.csv.gz
# 	rsync --checksum data-raw/* data/ 
# 	python scripts/python/transform.py $*
# 	rm data-raw/*

$(VALIDATION_REPORTS): logs/validation/%.json: scripts/python/validate.py data/%.csv.gz schemas/%.yaml
	python $< $* > $@

parse: $(SQL_FILES)

$(SQL_FILES): scripts/sql/%.sql: scripts/r/parse-sql.R schemas/%.yaml
	Rscript --verbose $< $* 2> logs/sql/$*.Rout

vars: 
	@echo 'RESOURCES:' $(RESOURCES)
	@echo
	@echo 'VALIDATION_REPORTS:' $(VALIDATION_REPORTS)
	@echo
	@echo 'DATA_RAW_FILES:' $(DATA_RAW_FILES)
