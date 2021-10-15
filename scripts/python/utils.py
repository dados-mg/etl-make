import csv, os
import hashlib
from frictionless import Package
from dpckan import update_resource
import pymysql

def extract_resource(resource_name):
    conn = pymysql.connect(host='192.168.33.11',
                           user='root',
                           password='root',
                           database='age7',
                           cursorclass=pymysql.cursors.DictCursor)
    cur = conn.cursor()
    sql_file = open(f'scripts/sql/{resource_name}.sql')
    sql_query = sql_file.read()
    cur.execute(sql_query)

    rows = cur.fetchall()

    colnames = [desc[0] for desc in cur.description]

    with open(f'data/raw/{resource_name}.csv', "w") as fp:
        myFile = csv.DictWriter(fp, colnames)
        myFile.writeheader()
        myFile.writerows(rows)

def update_resource_hash(resource_name):
    
    dp = Package('datapackage.json')
    resource = dp.get_resource(resource_name)
    md5_hash = hashlib.md5()
    file = open(resource.path, "rb")
    content = file.read()
    md5_hash.update(content)
    resource.stats.update({'hash': md5_hash.hexdigest()})
    dp.to_json('datapackage.json')

def load_resource(resource_name): 

    dp = Package('./datapackage.json')
    resources_id = list(filter(lambda x: x['url'] == os.environ.get('CKAN_HOST'), dp['ckan_host']))[0]['resources_id']

    # A chamada de funções via código Python exige passagem de todos os argumentos
    update_resource.update_resource(ckan_host=os.environ.get('CKAN_HOST'),
                        ckan_key=os.environ.get('CKAN_KEY'),
                        datapackage='./datapackage.json',
                        resource_name=resource_name,
                        resource_id=resources_id[resource_name])