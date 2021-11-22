import ipdb
import os
import yaml

def create_datasets_folder():
  if not os.path.exists("datasets"):
    os.system('mkdir datasets')
    resources_file = 'age7.yaml'
    resources_file = open(resources_file, encoding='utf-8').read()
    resources_file = yaml.load(resources_file, Loader=yaml.FullLoader)
    for dataset in resources_file['consultas'].keys():
      if not os.path.exists(f'datasets/{dataset}'):
        os.system(f'mkdir datasets/{dataset}')
        os.system(f'cp -r templates/description datasets/{dataset}')
        fact_tables = resources_file['consultas'][dataset]['fact_tables']
        resources = datapackage_yaml_resources(resources_file, fact_tables)
        base_file = open('templates/datapackage.yaml', encoding='utf-8').read()
        base_file = yaml.load(base_file, Loader=yaml.FullLoader)
        base_file['resources'] = resources
        with open(f'datasets/{dataset}/datapackage.yaml', 'w', encoding='utf-8') as f:
          yaml.dump(base_file, f, allow_unicode=True)

def datapackage_yaml_resources(resources_file, fact_tables):
  resources = []
  for fact_table in fact_tables:
    resources.append(build_resource(fact_table))
    if fact_table in resources_file['fact_tables'].keys():
      for dim_table in resources_file['fact_tables'][fact_table]:
        resources.append(build_resource(dim_table))
    else:
      print(f"{fact_table} não existente em data['fact_tables']")
  return resources

def build_resource(table):
  resource = {
    'name': table,
    'path': f'data/{table}.csv.gz',
    'schema': f'schema/{table}.csv.gz',
    'dialect': 'schema/dialect-v1.json',
    "profile": 'tabular-data-resource',
    "format": 'csv',
    "encoding": 'UTF-8',
    "title": '',
    "description": ''
  }
  return resource

if __name__ == '__main__':
  create_datasets_folder()
  # ipdb.set_trace(context=10)

