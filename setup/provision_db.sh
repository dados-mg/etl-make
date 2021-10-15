echo "Criando banco AGE7 e Tabelas"
mysql -uroot -proot < /vagrant/setup/AGE7.sql

echo "Inserindo dados nas tabelas"
mysql -uroot -proot < /vagrant/setup/dm_unidade_orc.sql
mysql -uroot -proot < /vagrant/setup/ft_receita_v2018.sql
