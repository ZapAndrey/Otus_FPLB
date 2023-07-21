#!/bin/bash
#Установка и настройка apache&wordpress
apt install -y apache2 apache2-utils php php-fpm php-mysqlnd
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
rsync -avP ~/wordpress/ /var/www/html/
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/wp-config.php
mv wp-config.php /var/www/html/
chown -R www-data:www-data /var/www/html/*
rm -Rf /var/www/html/index.html
systemctl enable apache2 --now
a2enmod php7.4
a2enmod rewrite

#настраиваем virtualhost apache на порт 81 
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/test_web.conf
mv test_web.conf /etc/apache2/sites-enabled/
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/index.html
if [ "$(hostname)" == backend1 ]; then sed -i -e "s/green/red/g" /root/index.html
sed -i -e "s/Apache2/Apache1/g" /root/index.html else 2
fi
mkdir /var/www/test_web
mv index.html /var/www/test_web/
echo "Listen 81" >> /etc/apache2/ports.conf
systemctl restart apache2


echo "Downloading and installing filebeat"
wget ftp://172.20.21.52/pub/filebeat-7.11.1-amd64.deb
dpkg -i filebeat-*.deb
#sed -i -e "s/#host: \"localhost:5601\"/host: \"localhost:5601\"/g" /etc/filebeat/filebeat.yml
wget -q https://raw.githubusercontent.com/ZapAndrey/Otus_FPLB/main/filebeat_back.yml
mv -f filebeat_back.yml /etc/filebeat/filebeat.yml
mv /etc/filebeat/modules.d/elasticsearch.yml.disabled /etc/filebeat/modules.d/elasticsearch.yml
mv /etc/filebeat/modules.d/apache.yml.disabled /etc/filebeat/modules.d/apache.yml
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
echo "Starting node_exporter.service..."
sudo systemctl daemon-reload
sudo systemctl start node_exporter.service
echo "Enabling node_exporter.services"
sudo systemctl enable node_exporter.service

#systemctl status apache2
#systemctl status node_exporter.service