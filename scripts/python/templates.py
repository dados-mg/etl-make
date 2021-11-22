import ipdb
import os
import yaml

def create_datasets_folder():
  if not os.path.exists("datasets"):
    os.system('mkdir datasets')
    input_file = 'age7.yaml'
    data = yaml.load(open(input_file, encoding='utf-8').read(), Loader=yaml.FullLoader)
    for dataset in data['consultas'].keys():
      if not os.path.exists(f'datasets/{dataset}'):
        os.system(f'mkdir datasets/{dataset}')
        os.system(f'cp -r templates/description datasets/{dataset}')
        fact_tables = data['consultas'][dataset]['fact_tables']
        resources = datapackage_yaml_resources(data, fact_tables)
        base_yaml_file = yaml.load(open('templates/datapackage.yaml', encoding='utf-8').read(), Loader=yaml.FullLoader)
        base_yaml_file['resources'] = resources
        with open(f'datasets/{dataset}/datapackage.yaml', 'w', encoding='utf-8') as f:
          yaml.dump(base_yaml_file, f, allow_unicode=True)

def datapackage_yaml_resources(data, fact_tables):
  resources = []
  for fact_table in fact_tables:
    resources.append({
      'name': fact_table,
      'path': f'data/{fact_table}.csv.gz'
      })
    if fact_table in data['fact_tables'].keys():
      for dim_table in data['fact_tables'][fact_table]:
        resources.append({
          'name': dim_table,
          'path': f'data/{dim_table}.csv.gz'
          })
    else:
      print(f"{fact_table} não existente em data['fact_tables']")
  return resources

if __name__ == '__main__':
  create_datasets_folder()
  # ipdb.set_trace(context=10)

