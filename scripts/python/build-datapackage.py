import os
from frictionless import Package
from utils import update_resource_hash

dp = Package('./datapackage.yaml')

readme = os.path.join(dp.basepath, 'README.md')
contributing = os.path.join(dp.basepath, 'CONTRIBUTING.md')
changelog = os.path.join(dp.basepath, 'CHANGELOG.md')

if os.path.isfile(readme):
    dp.update({'description': f"{dp.get('description')}\n{open(readme).read()}"})

if os.path.isfile(contributing):
    dp.update({'description': f"{dp.get('description')}\n{open(contributing).read()}"})

if os.path.isfile(changelog):
    dp.update({'description': f"{dp.get('description')}\n{open(changelog).read()}"})

for resource in dp.resources:
    resource.infer(stats = True)
    resource.expand()

dp.to_json('datapackage.json')