#!/bin/bash
#ecnfyjdrf необходимых компонентов
yum -y install deltarpm
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

echo "install rsync"
yum -y install rsync
sleep 2

echo "install curl"
yum -y install curl
sleep 2

echo "install wget"
yum -y install wget

#echo "install nginx"
#yum -y install nginx
#sleep 2
#systemctl enable nginx --now

#Установка и настройка filebeat
echo "Downloading and installing filebeat"
wget ftp://172.20.21.52/pub/filebeat-7.11.1-x86_64.rpm
rpm -ivh filebeat-*
#sed -i -e "s/#host: \"localhost:5601\"/host: \"localhost:5601\"/g" /etc/filebeat/filebeat.yml
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/filebeat_ng.yml
mv -f filebeat_ng.yml /etc/filebeat/filebeat.yml
#systemctl enable filebeat --now

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

#Установка Prometheus
useradd --no-create-home --shell /usr/bin/false prometheus
mkdir -m 755 {/etc/,/var/lib/}prometheus
#mkdir /temp
#cd /temp
wget https://github.com/prometheus/prometheus/releases/download/v2.37.8/prometheus-2.37.8.linux-amd64.tar.gz
tar -C /temp -xvf /temp/prometheus-2.37.8.linux-amd64.tar.gz --strip-components 1
rsync --chown=prometheus:prometheus -arvP consoles console_libraries /etc/prometheus/
rsync --chown=prometheus:prometheus -arvP prometheus.yml /etc/prometheus/prometheus.yml
rsync --chown=prometheus:prometheus -arvuP prometheus promtool /usr/local/bin/
#chown -v -R prometheus: /etc/prometheus/
chown -v -R prometheus: /var/lib/prometheus/
echo "Downloading prometheus.yml"
rm -rf /temp/*
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/prometheus.yml
mv -f prometheus.yml /etc/prometheus/
chown -v -R prometheus: /etc/prometheus/
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/prometheus.service
mv -f prometheus.service /etc/systemd/system/
rm -Rf /temp
systemctl daemon-reload
systemctl enable prometheus.service --now


#Установка Grafana
yum install -y https://dl.grafana.com/oss/release/grafana-10.0.2-1.x86_64.rpm
systemctl enable grafana-server --now
#импортируем подключение к prometheus 
curl -X POST -H "Content-Type: application/json" --data '{"id":1,"uid":"cc5293a2-812d-4089-b070-d8d530284223","orgId":1,"name":"Prometheus","type":"prometheus","typeName":"Prometheus","typeLogoUrl":"public/app/plugins/datasource/prometheus/img/prometheus_logo.svg","access":"proxy","url":"http://localhost:9090","user":"","database":"","basicAuth":false,"isDefault":true,"jsonData":{"httpMethod":"POST"},"readOnly":false}' "http://172.20.21.56:3000/api/datasources" -u admin:admin



















































 