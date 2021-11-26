#!/bin/bash

echo "Initial setup.  This may take a few minutes ..."
apt-get update

apt-get install -y build-essential jq # install gcc g++ and make

echo "Installing python..."
apt-get install -y python3 python3-venv python3-dev libpq-dev

echo "Installing python packages..."
python3 -m venv $VENV_PATH
source $VENV_PATH/bin/activate
pip install --upgrade pip
pip install wheel
pip install -r $PROJECT_PATH/requirements.txt

echo "Installing R..."
# https://cran.r-project.org/bin/linux/ubuntu/
apt-get install -y --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/"
apt-get install -y --no-install-recommends r-base
apt-get install -y r-base-dev # build requirements for R packages such as llapack lblas lgfortran
apt-get install -y libpng-dev # system requirement of png R package

cd $PROJECT_PATH && Rscript -e "install.packages('renv')" && Rscript -e 'renv::restore()'

echo "The environment has been installed."
echo
echo "You can start the machine by running: vagrant up"
echo "You can ssh to the machine by running: vagrant ssh"
echo "You can stop the machine by running: vagrant halt"
echo "You can delete the machine by running: vagrant destroy"
echo
exit 0
