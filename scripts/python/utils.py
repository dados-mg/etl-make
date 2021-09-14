import psycopg2, csv, sys
import hashlib
from frictionless import Package

def extract_resource(resource_name):

    conn = psycopg2.connect('postgresql://fjunior:170389@10.0.2.2:5432/fjunior')
    cur = conn.cursor()
    sql_file = open(f'scripts/sql/{resource_name}.sql')
    sql_query = sql_file.read()
    cur.execute(sql_query)

    rows = cur.fetchall()

    colnames = [desc[0] for desc in cur.description]

    with open(f'data/staging/{resource_name}.csv', "w") as fp:
        myFile = csv.writer(fp)
        myFile.writerow(colnames)
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