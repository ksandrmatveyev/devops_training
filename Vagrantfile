Vagrant.configure("2") do |config|
	config.vm.box = "bertvv/centos72"

	config.vm.define "nogitserver" do |nogit_serv|
		nogit_serv.vm.hostname="nogitserver"
		nogit_serv.vm.network "forwarded_port", guest: 80, host: 8081
		# nogit_serv.vm.network "private_natwork", ip:"172.20.20.10"
	end
	
	config.vm.define "gitserver" do |git_serv|
		git_serv.vm.hostname="gitserver"
		git_serv.vm.network "forwarded_port", guest: 80, host: 8082
		# git_serv.vm.network "private_natwork", ip:"172.20.20.11"
		git_serv.vm.provision "get_git", type: "shell", inline: "sudo yum install git -y"
		git_serv.vm.provision "clone_repo", type: "shell", inline: "sudo git clone https://github.com/ksandrmatveyev/devops_training.git && cd devops_training && sudo git checkout task1"
	end
end
