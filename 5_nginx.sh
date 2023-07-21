#!/bin/bash
#ecnfyjdrf необходимых компонентов
echo "stop and disable firewalld and selinux"
setenforce 0
sed -i -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
sleep 2

echo "add centos7 epel repository and installation"
yum -y install epel-release
sleep 2

echo "install nano"
yum -y install nano
sleep 2
yum -y install rsync
echo "install curl"
yum -y install curl
sleep 2

echo "install wget"
yum -y install wget

#Установка nginx и настройка балансировки
echo "install nginx"
yum -y install nginx
sleep 2
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/nginx_upstream
sed -i -e '/http {/r nginx_upstream' /etc/nginx/nginx.conf

nginxPath="/etc/nginx/conf.d/upstream.conf"
echo "server {" > $nginxPath
echo -e ' \t' "location / {" >> $nginxPath
echo -e ' \t' "proxy_pass http://backend;" >> $nginxPath
echo -e ' \t' "}" >> $nginxPath
echo -e ' \t' "location /wp {" >> $nginxPath
echo -e ' \t' "proxy_pass http://wp/;" >> $nginxPath
echo -e ' \t' "}" >> $nginxPath
echo "}" >> $nginxPath
systemctl enable nginx --now

#Установка и настройка filebeat
echo "Downloading and installing filebeat"
wget ftp://172.20.21.52/pub/filebeat-7.11.1-x86_64.rpm
rpm -ivh filebeat-*
#sed -i -e "s/#host: \"localhost:5601\"/host: \"localhost:5601\"/g" /etc/filebeat/filebeat.yml
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/filebeat_ng.yml
mv -f filebeat_ng.yml /etc/filebeat/filebeat.yml
#mv /etc/filebeat/modules.d/elasticsearch.yml.disabled /etc/filebeat/modules.d/elasticsearch.yml
#mv /etc/filebeat/modules.d/apache.yml.disabled /etc/filebeat/modules.d/apache.yml
systemctl enable filebeat --now

#Установка и настройка node_exporter
mkdir /temp/
cd /temp/
echo "downloading node_exporter..."
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
tar -C /temp -xvf /temp/node_exporter-1.6.0.linux-amd64.tar.gz --strip-components 1
echo "Creating user node_exporter"
useradd --no-create-home --shell /usr/sbin/nologin node_exporter
echo "Copying node_exporter to /usr/local/bin..."
rsync --chown=node_exporter:node_exporter -arvuP node_exporter /usr/local/bin/

NodeExpPath="/etc/systemd/system/node_exporter.service"
echo "[Unit]" > $NodeExpPath
echo "Description=Node Exporter" >> $NodeExpPath
echo "Wants=network-online.target" >> $NodeExpPath
echo "After=network-online.target" >> $NodeExpPath
echo "[Service]" >> $NodeExpPath
echo "User=node_exporter" >> $NodeExpPath
echo "Group=node_exporter" >> $NodeExpPath
echo "Type=simple" >> $NodeExpPath
echo "ExecStart=/usr/local/bin/node_exporter" >> $NodeExpPath
echo "[Install]" >> $NodeExpPath
echo "WantedBy=multi-user.target" >> $NodeExpPath
chown node_exporter:node_exporter /etc/systemd/system/node_exporter.service
systemctl daemon-reload
sudo systemctl enable node_exporter.service --now