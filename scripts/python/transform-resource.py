import argparse
from utils import update_resource_hash
from frictionless import Package

parser = argparse.ArgumentParser()
parser.add_argument("resource_name", help="name of the resource to be updated in respect to hash of data")
args = parser.parse_args()

dp = Package('datapackage.json')

resource = dp.get_resource(args.resource_name)

update_resource_hash(resource.name)