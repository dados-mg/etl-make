import argparse
from utils import load_resource
from frictionless import Package

parser = argparse.ArgumentParser()
parser.add_argument("resource_name", help="name of the resource to be loaded to ckan")
args = parser.parse_args()

dp = Package('datapackage.json')

resource = dp.get_resource(args.resource_name)

load_resource(resource.name)