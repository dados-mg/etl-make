import argparse
from utils import extract_resource
from frictionless import Package

parser = argparse.ArgumentParser()
parser.add_argument("resource_name", help="name of the resource to be extracted to data/staging/")
args = parser.parse_args()

dp = Package('datapackage.yaml')

resource = dp.get_resource(args.resource_name)

extract_resource(resource.name)
