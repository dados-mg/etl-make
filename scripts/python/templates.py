import ipdb
import os
import yaml
import json
from frictionless import Package

def build():
  create_datasets_build_folder()

def create_datasets_folder():
  if not os.path.exists("datasets"):
    os.system('mkdir datasets')
  from_to_file = load_from_to_file()
  for dataset in from_to_file['consultas'].keys():
    if not os.path.exists(f'datasets/{dataset}'):
      os.system(f'mkdir datasets/{dataset}')
      os.system(f'cp -r templates/* datasets/{dataset}')

def create_datasets_build_folder():
  if os.path.exists("build_datasets"):
    print('Pasta datasets_build existente, confira se algum erro ocorreu durante último building.')
  else:
    os.system('mkdir build_datasets')
    from_to_file = load_from_to_file()
    for dataset in from_to_file['consultas'].keys():
      os.system(f'mkdir build_datasets/{dataset}')
      os.system(f'mkdir build_datasets/{dataset}/data')
      os.system(f'mkdir build_datasets/{dataset}/schemas')
      os.system(f'cp datasets/{dataset}/*.md build_datasets/{dataset}')
      # Lê o arquivo datapackage.json para, entre outros, extrair os recursos daquele conjunto
      base_dp = Package('datapackage.json')
      # Lê o arquivo datasets/conjunto/datapakcage.yaml para extrair os metadados personalizados do conjunto
      target_dp = Package(f'datasets/{dataset}/datapackage.yaml')
      # Inclui no base_dp os metadados extraídos do arquivo datapackage.yaml
      for k in target_dp.keys():
        base_dp[k] = target_dp[k]
      base_dp['name'] = dataset
      base_dp['title'] = from_to_file['consultas'][dataset]['title']
      base_dp['homepage'] = from_to_file['consultas'][dataset]['url']
      fact_tables = from_to_file['consultas'][dataset]['fact_tables']
      target_resources = find_target_resources(from_to_file, fact_tables)
      resources_diff = find_resource_diff(base_dp.resource_names, target_resources)
      base_dp = remove_resources(base_dp, resources_diff)
      base_dp = update_resource_properties(base_dp)
      base_dp.to_json(f'build_datasets/{dataset}/datapackage.json')

def find_resource_diff(original_resources, target_resources):
  resources_diff = [i for i in original_resources if not i in target_resources]
  return resources_diff

def remove_resources(base_dp, resources_diff):
  for resource in resources_diff:
    base_dp.remove_resource(resource)
  return base_dp

def update_resource_properties(base_dp):
  for resource in base_dp.resource_names:
    path = base_dp.get_resource(resource).path
    schema = base_dp.get_resource(resource)['schema']
    dialect = base_dp.get_resource(resource)['dialect']
    new_path = f'build_datasets/{base_dp.name}/{path}'
    base_dp.get_resource(resource).path = new_path
    os.system(f'cp {path} {new_path}')
    if isinstance(schema, str):
      new_schema = f'build_datasets/{base_dp.name}/{schema}'
      base_dp.get_resource(resource)['schema'] = new_schema
      if not os.path.exists(new_schema):
        os.system(f'cp {schema} {new_schema}')
    if isinstance(dialect, str):
      new_dialetic = f'build_datasets/{base_dp.name}/{dialect}'
      base_dp.get_resource(resource)['dialect'] = new_dialetic
      if not os.path.exists(new_dialetic):
        os.system(f'cp {dialect} {new_dialetic}')
  return base_dp

def load_from_to_file():
  from_to_file = 'age7.yaml'
  from_to_file = open(from_to_file, encoding='utf-8').read()
  from_to_file = yaml.load(from_to_file, Loader=yaml.FullLoader)
  return from_to_file

def find_target_resources(from_to_file, fact_tables):
  target_resources = []
  for fact_table in fact_tables:
    target_resources.append(fact_table)
    if fact_table in from_to_file['fact_tables'].keys():
      for dim_table in from_to_file['fact_tables'][fact_table]:
        if dim_table not in target_resources:
          target_resources.append(dim_table)
    else:
      print(f"{fact_table} não existente em data['fact_tables']")
  return target_resources

if __name__ == '__main__':
  os.system(f'rm -rf build_datasets/') # Facilitar os testes
  build()
  # create_datasets_folder()
  # ipdb.set_trace(context=10)

