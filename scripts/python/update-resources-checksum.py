import argparse
from utils import update_resource_hash
from frictionless import Package

dp = Package('datapackage.json')

for resource in dp.resources:
    update_resource_hash(resource.name)
