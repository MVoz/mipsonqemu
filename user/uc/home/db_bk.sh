#! /bin/sh
source config.sh
##BakDir=`pwd`
LogFile=mysqlbak.log
DATE=`date +%Y%m%d`
#cd $BakDir
#DumpFile=$DATE.sql
DumpFile=uc_db.sql
rm -fr $DumpFile.sql.zip
#GZDumpFile=$DATE.sql.tgz
GZDumpFile=$DumpFile.tgz

mysqldump --quick --databases $DBNAME --flush-logs --delete-master-logs --lock-all-tables --default-character-set=utf8 -u $DB_USER -p$mysql_passwd > $DumpFile
zip  -u -P $rar_passwd $DumpFile.zip $DumpFile uc_bookmark.sdr config.sh  bm_logo.psd
rm -f $DumpFile 
rm -f $LogFile
#svn commit -m "$DATA"
echo "Backup Done!"
