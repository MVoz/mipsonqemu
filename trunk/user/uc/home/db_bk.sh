#! /bin/sh
##BakDir=`pwd`
LogFile=mysqlbak.log
DATE=`date +%Y%m%d`
#cd $BakDir
#DumpFile=$DATE.sql
DumpFile=uc_db.sql
#GZDumpFile=$DATE.sql.tgz
GZDumpFile=$DumpFile.tgz
DBNAME=uc_db

DB_USER=root

DB_PASSWORD=060710

mysqldump --quick --databases $DBNAME --flush-logs --delete-master-logs --lock-all-tables --default-character-set=utf8 -u $DB_USER -p060710 > $DumpFile
#echo "Dump Done" >> $LogFile
tar czvf $GZDumpFile $DumpFile >> $LogFile 2>&1
#echo "[$GZDumpFile]Backup Success!" >> $LogFile
rm -f $DumpFile 
rm -f $LogFile
echo "Backup Done!"
