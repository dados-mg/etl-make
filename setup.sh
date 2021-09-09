#!/bin/bash

echo "Initial setup.  This may take a few minutes ..."
apt-get update

apt-get install build-essential jq # install gcc g++ and make

echo "Installing python..."
apt-get install -y python3 python3-venv python3-dev libpq-dev

echo "Installing python packages..."
python3 -m venv ~/.virtualenvs/etl-make
source ~/.virtualenvs/etl-make/bin/activate
pip install wheel
pip install -r /vagrant/requirements.txt
# if [ $? -gt 0 ]; then
#     echo 2> 'Unable to install python requirements from requirements.txt'
#     exit 1
# fi

echo "Installing R..."
# https://cran.r-project.org/bin/linux/ubuntu/
apt-get install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/"
apt-get install --no-install-recommends r-base
apt-get install libpng-dev # system requirement of png R package

cd /vagrant && Rscript -e "install.packages(renv)" && Rscript -e 'renv::restore()'

echo "The environment has been installed."
echo
echo "You can start the machine by running: vagrant up"
echo "You can ssh to the machine by running: vagrant ssh"
echo "You can stop the machine by running: vagrant halt"
echo "You can delete the machine by running: vagrant destroy"
echo
exit 0