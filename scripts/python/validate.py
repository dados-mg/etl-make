import os
import sys
import json
from frictionless import Package
from frictionless import validate_resource

def validate(resource_name):
  package = Package('datapackage.yaml')
  resource = package.get_resource(resource_name)
  report = validate_resource(resource)
  json.dump(report, sys.stdout, indent=2)
  
if __name__ == '__main__':
    validate(sys.argv[1])