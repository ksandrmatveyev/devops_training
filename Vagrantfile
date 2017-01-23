$wrk_prop = <<SCRIPT
echo 'worker.list=loadbalancer,status
worker.status.type=status
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=tomcat1,tomcat2
worker.tomcat1.host=172.20.20.22
worker.tomcat1.port=8009
worker.tomcat1.type=ajp13
worker.tomcat2.host=172.20.20.23
worker.tomcat2.port=8009
worker.tomcat2.type=ajp13' > /etc/httpd/conf/workers.properties
SCRIPT

$httpd_conf = <<SCRIPT
echo 'LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf/workers.properties
JkShmFile /tmp/shm
JkLogFile logs/mod_jk.log
JkLogLevel info
JkMount /testapp* loadbalancer
JkMount /status* status' >> /etc/httpd/conf/httpd.conf
SCRIPT


Vagrant.configure("2") do |config|
	config.vm.box = "bertvv/centos72"
	config.vm.provision "restart_network", run: "always", type: "shell", inline: "sudo systemctl restart network"
	config.vm.provision "disable_firewall", type: "shell", inline: "sudo systemctl stop firewalld && sudo systemctl disable firewalld"
	
	config.vm.define "apache" do |apache|
		apache.vm.hostname="apache"
		apache.vm.network "forwarded_port", guest: 80, host: 8180
		apache.vm.network "forwarded_port", guest: 8009, host: 8109
		apache.vm.network "forwarded_port", guest: 22, host: 2201, id: "ssh"
		apache.vm.network "private_network", ip: "172.20.20.21"
		apache.vm.provision "get_httpd", type: "shell", inline: "sudo yum install httpd -y"
		apache.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start httpd && sudo systemctl enable httpd"
		apache.vm.provision "copy_modjk", type: "shell", inline: "sudo cp /vagrant/mod_jk.so /etc/httpd/modules"
		apache.vm.provision "create_workproperties", type: "shell", inline: $wrk_prop
		apache.vm.provision "edit_httpdconf", type: "shell", inline: $httpd_conf
		apache.vm.provision "restart_httpd", type: "shell", inline: "sudo service httpd restart"
		
	end
	
	config.vm.define "tomcat1" do |tomcat1|
		tomcat1.vm.hostname="tomcat1"
		tomcat1.vm.network "forwarded_port", guest: 8080, host: 8280
		tomcat1.vm.network "forwarded_port", guest: 8009, host: 8209
		tomcat1.vm.network "forwarded_port", guest: 22, host: 2202, id: "ssh"
		tomcat1.vm.network "private_network", ip: "172.20.20.22"
		tomcat1.vm.provision "get_jre", type: "shell", inline: "sudo yum install java-1.8.0-openjdk -y"
		tomcat1.vm.provision "get_tomcat", type: "shell", inline: "sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y"
		tomcat1.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start tomcat && sudo systemctl enable tomcat"
		tomcat1.vm.provision "create_indexhtml", type: "shell", inline:	"sudo mkdir /usr/share/tomcat/webapps/testapp && sudo echo tomcat1 > /usr/share/tomcat/webapps/testapp/index.html"
		
	end
	
		config.vm.define "tomcat2" do |tomcat2|
		tomcat2.vm.hostname="tomcat2"
		tomcat2.vm.network "forwarded_port", guest: 8080, host: 8380
		tomcat2.vm.network "forwarded_port", guest: 8009, host: 8309
		tomcat2.vm.network "forwarded_port", guest: 22, host: 2203, id: "ssh"
		tomcat2.vm.network "private_network", ip: "172.20.20.23"
		tomcat2.vm.provision "get_jre", type: "shell", inline: "sudo yum install java-1.8.0-openjdk -y"
		tomcat2.vm.provision "get_tomcat", type: "shell", inline: "sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y"
		tomcat2.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start tomcat && sudo systemctl enable tomcat"
		tomcat2.vm.provision "create_indexhtml", type: "shell", inline:	"sudo mkdir /usr/share/tomcat/webapps/testapp && sudo echo tomcat2 > /usr/share/tomcat/webapps/testapp/index.html"
		
	end

end
