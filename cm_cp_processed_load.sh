#mysql -h crm-db-new..ap-south-1.rds.amazonaws.com -u rdscrm -p'Crms' -e "USE crm_cisars; LOAD DATA INFILE '/home/ubuntu/sandy/cm_cp_processed/cm_cp_processed.csv' INTO TABLE cm_cp_processed FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' IGNORE 1 LINES;" 

#mysqlimport --local -h crm-db.c2crlxbwioks.ap-south-1.rds.amazonaws.com -u rdscrm -p'Crmservic' crm_cisars /home/ubuntu/sandy/cm_cp_processed/cm_cp_processed.csv --fields-terminated-by=',' --lines-terminated-by='\n' --ignore-lines=1

#mysqldump --single-transaction --quick -h cmoldbw..creditmantri.com -u rdscmo --no-tablespaces --skip-triggers --set-gtid-purged=OFF  -p'aSdaKUq2eB' cmolbe cm_cp_processed | mysql -h crm-db.c2crlxbwioks.ap-south-1.rds.amazonaws.com -u rdscr -p'Crmservice_' crm_cisars

mysqldump --single-transaction --quick -h cmold.inside.creditmantri.com -u scmoldb --no-tablespaces --skip-triggers --set-gtid-purged=OFF  -p'aSdaKUq2e' cmolbeta cm_cp_processed | mysql -h crm-db.c2crlxbwioks.ap-south-1.rds.amazonaws.com -u rdscrmdb -p'service_cm24' crmbeta
#mysqldump --single-transaction --quick -h crm-db.c2crlxbwioks.ap-south-1.rds.amazonaws.com -u rdscrmdb --no-tablespaces --skip-triggers --set-gtid-purged=OFF  -p'service_cm24' crm_cisars cm_cp_processed | mysql -h crm-db.c2crlxbwioks.ap-south-1.rds.amazonaws.com -u rdscrmdb -p'service_cm24' crmbeta
