.PHONY: help extract

RESOURCES=$(shell cat datapackage.json | jq -r ' .resources | .[] | .name ')

VALIDATION_REPORTS=$(patsubst %, logs/validation/%.json, $(RESOURCES))

DATA_RAW_FILES := $(patsubst %, data-raw/%.csv, $(RESOURCES))

#====================================================================

# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

extract: $(DATA_RAW_FILES)

validate: $(VALIDATION_REPORTS)

ls: 
	rsync --checksum --dry-run --out-format='%n' data-raw/* data/

$(DATA_RAW_FILES): data-raw/%.csv: 
	python scripts/python/extract.py $*
	rsync --checksum data-raw/* data/ 
	python scripts/python/transform.py $*
	rm data-raw/*

$(VALIDATION_REPORTS): logs/validation/%.json: scripts/python/validate.py datapackage.json data/%.csv
	python scripts/python/validate.py $* > $@
