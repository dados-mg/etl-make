import ipdb
import os
import yaml

def create_datasets_folder():
  if not os.path.exists("datasets"):
    os.system('mkdir datasets')
    input_file = 'age7.yaml'
    data = yaml.load(open(input_file).read(), Loader=yaml.FullLoader)
    for dataset in data['consultas'].keys():
      if not os.path.exists(f'datasets/{dataset}'):
        os.system(f'mkdir datasets/{dataset}')
        os.system(f'cp -r templates/description datasets/{dataset}')
        os.system(f'cp templates/datapackage.yaml datasets/{dataset}/')

if __name__ == '__main__':
  create_datasets_folder()

