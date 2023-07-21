СХЕМА РЕАЛИЗУЕМОГО ПРОЕКТА
project_shema2.png 
**************************************************************************

РАЗВОРАЧИВАНИЕ СЕРВЕРОВ
1_monitoring.sh      мониторинг
2_elk.sh             логирование
3_1_mysql_master.sh  MySQL master
3_2_mysql_slave.sh   MySQL slave
4_backend1.sh        beckend (Apache+ WordPress)
5_nginx.sh           балансировщик
**************************************************************************

КОНФИГУРАЦИОННЫЕ ФАЙЛЫ
backupbd.sh 	бекап бд Wordpress потаблично

elasticsearch.yml конфигурирование Elasticsearch

filebeat_back.yml конфигурирование filebeat для backend

filebeat_db.yml	конфигурирование filebeat для MySQL

filebeat_ng.yml	конфигурирование filebeat для frontend

filter.conf 	фильтр logstash

index.html		стартовая страница backend

input.conf		вход логов logstash

nginx_upstream	конфигурирование балансировщика nginx

output.conf		выход логов logstash

prometheus.service	настройка сервиса prometheus
prometheus.yml		конфигурационный файл prometheus

test_web.conf	тестовый портал backend

wp-config.php	конфигурационный файл wordpress
