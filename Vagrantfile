Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "192.168.2.3"
  config.vm.network "public_network"
  config.vm.hostname = "dev.vagrant.com"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    v.customize ["modifyvm", :id, "--nictype3", "virtio"]
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--name", "VagrantMachine"]
  end
 
  config.vm.provision :shell, :inline => "sudo apt-get update && sudo apt-get install puppet -y"
  config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=vagrant
controluser_password=vagrant" > /etc/phpmyadmin.facts;'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file  = "default.pp"
    puppet.options = ['--verbose']
  end
  
  # create a database based on doctrine entities and populate using doctrine-data-fixtures (using ZF2 Doctrine Module)
  # config.vm.provision :shell, :inline => "/vagrant/vendor/bin/doctrine-module orm:schema-tool:create"
  # config.vm.provision :shell, :inline => "/vagrant/vendor/bin/doctrine-module data-fixture:import"
end
