# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # enable vagrant-env plugin
  # install with `vagrant plugin install vagrant-env` 
  config.env.enable
  
  config.vm.define "etl" do |etl|
    etl.vm.box = "ubuntu/bionic64"
    etl.vm.provision "shell", path: "setup/provision_etl.sh", env: {PROJECT_PATH:ENV['PROJECT_PATH'], VENV_PATH:ENV['VENV_PATH']}
    etl.vm.provision "shell", inline: 'echo ". /home/vagrant/venv/bin/activate && cd /vagrant" > ~/.profile', privileged: false
    etl.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "db" do |db|
    db.vm.box = "bigdeal/mysql57"
    db.vm.provision "shell", path: "setup/provision_db.sh"
    db.vm.network "private_network", ip: "192.168.33.11"
  end
end
