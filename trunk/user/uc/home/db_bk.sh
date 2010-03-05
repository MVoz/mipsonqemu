#! /bin/sh
source config.sh
##BakDir=`pwd`
LogFile=mysqlbak.log
DATE=`date +%Y%m%d`
#cd $BakDir
#DumpFile=$DATE.sql
DumpFile=uc_db.sql
#GZDumpFile=$DATE.sql.tgz
GZDumpFile=$DumpFile.tgz

mysqldump --quick --databases $DBNAME --flush-logs --delete-master-logs --lock-all-tables --default-character-set=utf8 -u $DB_USER -p$mysql_passwd > $DumpFile
#echo "Dump Done" >> $LogFile
#tar czvf $GZDumpFile $DumpFile >> $LogFile 2>&1
#echo "[$GZDumpFile]Backup Success!" >> $LogFile
zip  -u -P $rar_passwd $DumpFile.zip $DumpFile uc_bookmark.sdr config.sh
rm -f $DumpFile 
rm -f $LogFile
svn commit -m "$DATA"
echo "Backup Done!"
