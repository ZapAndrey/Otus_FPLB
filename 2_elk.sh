#!/bin/bash
#Установка необходимых компонентов
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

echo "install curl"
yum -y install curl
sleep 2

echo "install rsync"
yum -y install rsync
sleep 2

echo "install wget"
yum -y install wget
sleep 2

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

# УСТАНОВКА и НАСТРОЙКА ELK-stack
echo "Downloading and installing Java"
yum -y install java

mkdir /temp/
cd /temp
echo "Downloading and installing Elasticsearch"
#wget https://mirrors.huaweicloud.com/elasticsearch/7.8.0/elasticsearch-7.8.0-x86_64.rpm
wget ftp://172.20.21.52/pub/elasticsearch-7.15.1-x86_64.rpm
rpm -ivh elasticsearch-*
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/elasticsearch.yml
cp -f elasticsearch.yml /etc/elasticsearch/
sleep 2

echo "Downloading and installing logstash"
#wget https://mirrors.huaweicloud.com/logstash/7.8.0/logstash-7.8.0.rpm
wget ftp://172.20.21.52/pub/logstash-7.15.2-x86_64.rpm
rpm -ivh logstash-*
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/input.conf
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/filter.conf
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/output.conf
cp -f input.conf filter.conf output.conf /etc/logstash/conf.d/
sleep 2

echo "Downloading and installing kibana"
#wget https://mirrors.huaweicloud.com/kibana/7.8.0/kibana-7.8.0-x86_64.rpm
wget ftp://172.20.21.52/pub/kibana-7.15.1-x86_64.rpm
rpm -ivh kibana-*
sed -i -e "s/#server.port: 5601/server.port: 5601/g" /etc/kibana/kibana.yml
sed -i -e "s/#server.host: \"localhost\"/server.host: 0.0.0.0/g" /etc/kibana/kibana.yml
sed -i -e "s/#elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\]/elasticsearch.hosts: \[\"http:\/\/localhost:9200\"\]/g" /etc/kibana/kibana.yml
sleep 2

echo "Downloading and installing filebeat"
#wget https://mirrors.huaweicloud.com/filebeat/7.8.0/filebeat-7.8.0-x86_64.rpm
wget ftp://172.20.21.52/pub/filebeat-7.11.1-x86_64.rpm
rpm -ivh filebeat-*
sed -i -e "s/#host: \"localhost:5601\"/host: \"localhost:5601\"/g" /etc/filebeat/filebeat.yml
mv /etc/filebeat/modules.d/elasticsearch.yml.disabled /etc/filebeat/modules.d/elasticsearch.yml
mv /etc/filebeat/modules.d/apache.yml.disabled /etc/filebeat/modules.d/apache.yml
sleep 2

systemctl enable elasticsearch --now
sleep 5
systemctl enable kibana --now
sleep 5
systemctl enable logstash --now
sleep 5
systemctl enable filebeat --now

echo "Downloading and installing ELK complete!"