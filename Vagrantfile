# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/ubuntu2204"

  config.vm.provider "libvirt" do |vm|
    vm.memory = 8192
    vm.cpus = 2
  end

  # Provision Docker
  config.vm.provision "docker" do |d|
    d.pull_images "ubuntu"
    # d.run "container"
    # https://developer.hashicorp.com/vagrant/docs/provisioning/docker
  end

  # Provision kubectl
  config.vm.provision "shell", inline: <<-SHELL
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    kubectl version --client
  SHELL

    # Provision Kind
  config.vm.provision "shell", inline: <<-SHELL
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    kind --version
  SHELL

  # Install Terraform
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install -y terraform
    terraform version
  SHELL
  # https://developer.hashicorp.com/well-architected-framework/operational-excellence/verify-hashicorp-binary

end
