# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "etl" do |etl|
    etl.vm.box = "ubuntu/bionic64"
    etl.vm.provision "shell", path: "setup/provision.sh"
    etl.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "db" do |db|
    db.vm.box = "bigdeal/mysql57"
    db.vm.network "private_network", ip: "192.168.33.11"
  end
end
