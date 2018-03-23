Vagrant.configure(2) do |config|
    config.vm.define "devops" do |devops|
        devops.vm.box = "ubuntu/xenial64"
        devops.vm.network "private_network", ip: "192.168.11.11"
        
        ### provision
        devops.vm.provision "shell", path: "scripts/setup.sh"
        
        devops.vm.provider "virtualbox" do |vb|
            vb.memory = 2048
            vb.cpus = 2
        end
    end
end