#! /bin/sh
source config.sh

echo "Please choose the action:(1):commit (2):update (3):exit"

select item in commit update exit
do
	if [ $item = "commit" ];then
		echo 'backup is processing......'
		echo 'rm -fr '$sqlfile.sql'.zip'
		rm -fr $sqlfile.sql.zip
		echo 'backup mysql database'
		mysqldump --quick --databases $DBNAME --flush-logs --delete-master-logs --lock-all-tables --default-character-set=utf8 -u $DB_USER -p$mysql_passwd > $sqlfile
		echo 'make zip package '$sqlfile'.sql.zip'
		zip  -u -P $rar_passwd $sqlfile.zip $sqlfile uc_bookmark.sdr config.sh  bm_logo.psd
		rm -f $sqlfile 
		echo 'commit is processing......'
		for svni in $svnfiles
		do
		    echo 'svn commit '$svni
		    svn commit -m  '$logdate' $svni
		done

	elif  [ $item = "update" ];then
		echo 'unzip '$sqlfile.sql'.zip'
		unzip -xo -P $rar_passwd  $sqlfile.zip
		echo 'restore mysql database.......'
		mysql -u $DB_USER -p$mysql_passwd  < $sqlfile.sql
		echo 'update is processing......'
		for svni in $svnfiles
		do
		    echo 'svn update '$svni
		  #  svn update $svni
		done
	elif [ $item = "exit" ];then
	   break;
	else
	   echo "error!"
	fi
done

echo "Done !!!"
