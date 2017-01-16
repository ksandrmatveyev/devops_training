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
		git_serv.vm.provision "get_git", type: "shell" do |get_git|
			get_git.inline = "sudo yum install git -y"
		end
		git_serv.vm.provision "clone_repo", type: "shell" do |clone_repo|
			clone_repo.inline = "sudo git clone https://github.com/ksandrmatveyev/devops_training.git"
		end
		git_serv.vm.provision "switch_to_branch_task1", type: "shell" do |switch_branch|
			switch_branch.inline = "cd /home/vagrant/devops_training && sudo git checkout remotes/origin/task1"
		end
	end
end
