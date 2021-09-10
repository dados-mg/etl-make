from frictionless import Package
from utils import extract_resource

dp = Package('datapackage.json')

for resource in dp.resources:
    extract_resource(resource.name)
