#!/bin/bash
sudo echo "LoadModule jk_module modules/mod_jk.so" >> /etc/httpd/conf/httpd.conf
sudo echo "JkWorkersFile conf/workers.properties" >> /etc/httpd/conf/httpd.conf
sudo echo "JkShmFile /tmp/shm" >> /etc/httpd/conf/httpd.conf
sudo echo "JkLogFile logs/mod_jk.log" >> /etc/httpd/conf/httpd.conf
sudo echo "JkLogLevel info" >> /etc/httpd/conf/httpd.conf
sudo echo "JkMount /testapp* lb" >> /etc/httpd/conf/httpd.conf
