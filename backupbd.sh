#!/bin/bash

for DB in $(mysql -uroot -p'!PassBase1' -e "show databases like 'wordpres%_db'" --skip-column-names); 
  do
  
  mkdir /root/back_db/$DB -p
    for TAB in $(mysql -uroot -p'!PassBase1' -e "show tables from $DB like 'wp_%'" --skip-column-names);
      do
        mysqldump -uroot -p'!PassBase1' --master-data=2 $DB $TAB > /root/back_db/$DB/$DB_$TAB-$(date +\%Y-\%m-\%d).sql;
    done
  echo $DB
  
done