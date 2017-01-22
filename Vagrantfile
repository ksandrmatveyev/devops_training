Vagrant.configure("2") do |config|
	config.vm.box = "bertvv/centos72"
	
	config.vm.define "apache" do |apache|
		apache.vm.hostname="apache"
		apache.vm.network "forwarded_port", guest: 22, host: 2001
		apache.vm.network "forwarded_port", guest: 80, host: 8180
		apache.vm.network "forwarded_port", guest: 8009, host: 8109
		apache.vm.network "private_network", ip: "172.20.20.20"
		apache.vm.provision "restart_network", run: "always", type: "shell", inline: "sudo systemctl restart network"
				
		#apache.vm.provision "get_apache", type: "shell", inline: "sudo yum install apache -y"
		apache.vm.provision "get_httpd", type: "shell", inline: "sudo yum install httpd -y"
		apache.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start httpd && sudo systemctl enable httpd"
		apache.vm.provision "disable_firewall", type: "shell", inline: "sudo systemctl stop firewalld && sudo systemctl disable firewalld"
		apache.vm.provision "copy_modjk", type: "shell", inline: "sudo cp /vagrant/mod_jk.so /etc/httpd/modules"
		apache.vm.provision "create_workproperties", type: "shell", inline: "sudo touch /etc/httpd/conf/workers.properties && sudo echo worker.list=lb >> /etc/httpd/conf/workers.properties && sudo echo worker.type=lb >> /etc/httpd/conf/workers.properties && sudo echo worker.balance_workers=tomcat1,tomcat2 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat1.host=172.20.20.21 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat1.port=8009 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat1.type=ajp13 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat2.host=172.20.20.22 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat2.port=8009 >> /etc/httpd/conf/workers.properties && sudo echo worker.tomcat2.type=ajp13 >> /etc/httpd/conf/workers.properties"
		apache.vm.provision "edit_httpdconf", type: "shell", path: "edit_httpdconf.sh"
		apache.vm.provision "restart_httpd", type: "shell", inline: "sudo service httpd restart"
		
	end
	
	config.vm.define "tomcat1" do |tomcat1|
		tomcat1.vm.hostname="tomcat1"
		tomcat1.vm.network "forwarded_port", guest: 22, host: 2002
		tomcat1.vm.network "forwarded_port", guest: 8080, host: 8280
		tomcat1.vm.network "forwarded_port", guest: 8009, host: 8209
		tomcat1.vm.network "private_network", ip: "172.20.20.21"
		tomcat1.vm.provision "restart_network", run: "always", type: "shell", inline: "sudo systemctl restart network"
		
		tomcat1.vm.provision "get_jre", type: "shell", inline: "sudo yum install java-1.8.0-openjdk -y"
		tomcat1.vm.provision "get_tomcat", type: "shell", inline: "sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y"
		tomcat1.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start tomcat && sudo systemctl enable tomcat"
		tomcat1.vm.provision "disable_firewall", type: "shell", inline: "sudo systemctl stop firewalld && sudo systemctl disable firewalld"
		tomcat1.vm.provision "create_indexhtml", type: "shell", inline:	"sudo mkdir /usr/share/tomcat/webapps/testapp && touch /usr/share/tomcat/webapps/testapp/index.html && sudo echo tomcat1 >> /usr/share/tomcat/webapps/testapp/index.html"
		
	end
	
		config.vm.define "tomcat2" do |tomcat2|
		tomcat2.vm.hostname="tomcat2"
		tomcat2.vm.network "forwarded_port", guest: 22, host: 2003
		tomcat2.vm.network "forwarded_port", guest: 8080, host: 8380
		tomcat2.vm.network "forwarded_port", guest: 8009, host: 8309
		tomcat2.vm.network "private_network", ip: "172.20.20.22"
		tomcat2.vm.provision "restart_network", run: "always", type: "shell", inline: "sudo systemctl restart network"
		
		tomcat2.vm.provision "get_jre", type: "shell", inline: "sudo yum install java-1.8.0-openjdk -y"
		tomcat2.vm.provision "get_tomcat", type: "shell", inline: "sudo yum install tomcat tomcat-webapps tomcat-admin-webapps -y"
		tomcat2.vm.provision "start_restart", type: "shell", inline: "sudo systemctl start tomcat && sudo systemctl enable tomcat"
		tomcat2.vm.provision "disable_firewall", type: "shell", inline: "sudo systemctl stop firewalld && sudo systemctl disable firewalld"	
		tomcat2.vm.provision "create_indexhtml", type: "shell", inline:	"sudo mkdir /usr/share/tomcat/webapps/testapp && touch /usr/share/tomcat/webapps/testapp/index.html && sudo echo tomcat2 >> /usr/share/tomcat/webapps/testapp/index.html"
		
	end
	
end
