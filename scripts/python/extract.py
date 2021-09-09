import psycopg2, csv, sys

def extract(resource_name):

    conn = psycopg2.connect('postgresql://fjunior:170389@10.0.2.2:5432/fjunior')
    cur = conn.cursor()
    sql_file = open(f'scripts/sql/{resource_name}.sql')
    sql_query = sql_file.read()
    cur.execute(sql_query)

    rows = cur.fetchall()

    colnames = [desc[0] for desc in cur.description]

    with open(f'data-raw/{resource_name}.csv', "w") as fp:
        myFile = csv.writer(fp)
        myFile.writerow(colnames)
        myFile.writerows(rows)

    return exit(0)

if __name__ == '__main__':
    extract(sys.argv[1])