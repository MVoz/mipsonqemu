#include <QApplication>
#include <QString>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <QTextStream>
#include <windows.h>
#include <shlobj.h>
#include <QSqlQuery>
#include <QSqlDatabase>
#include <qDebug>
#include <QObject>
#include <QVariant>
#include <QTextCodec>
#define BOOKMARK_CATAGORY_FLAG 1
#define BOOKMARK_ITEM_FLAG 2
#define MASK_TYPE 0x03

#define PINYIN_DB_FILENAME "pinyin.db"
#define PINYIN_DB_TABLENAME "pytable"

uint qhashEx(QString str, int len)
{
    uint h = 0;
    int g=0;
	int i=0;
    while (len--) {
		QChar c=str.at(i++);
        h = ((h) << 4) +c.unicode();
        if ((g = (h & 0xf0000000)) != 0)
            h ^= g >> 23;
        h &= ~g;
    }
    return h;
}
bool importfile(QSqlDatabase& db)
{
	QFile f("words.txt");
	f.open(QIODevice::ReadOnly | QIODevice::Text);
	QSqlQuery q("",db);
	db.transaction();
	int i = 0;
	while(!f.atEnd())
	{
		QString s=f.readLine();
		s=QTextCodec::codecForName("UTF-8")->toUnicode(s.toLatin1()); 
		if(s.size()<=1)
			continue;
		s.remove(s.size()-1,1);
		//	qDebug()<<s.size()<<"  "<<s.toLocal8Bit().length();
		if(i&&!(i%100))
		{
			db.commit();
			q.clear();
			db.transaction();
		}

			q.exec(QString("insert into %1(word,pinyin,hashId) values('%2','%3',%4)")
			.arg(PINYIN_DB_TABLENAME)
			.arg(QString(s.at(0)))
			.arg(s.right(s.length()-2))
			.arg(qhashEx(QString(s.at(0)),1))
			);

		i++;
	}
	db.commit();
	q.clear();
	f.close();
	return true;
}


bool createDbFile(QSqlDatabase& db)
{
		QString queryStr;
		QSqlQuery query("",db);
		query.exec(QString("DROP TABLE %1").arg(PINYIN_DB_TABLENAME));	
		query.exec(
					QString("CREATE TABLE %1 ("
				   "id INTEGER PRIMARY KEY AUTOINCREMENT, "
				   "word VARCHAR(16) NOT NULL, "
				   "pinyin VARCHAR(256) NOT NULL, "
				   "hashId INTEGER NOT NULL)"
				    ).arg(PINYIN_DB_TABLENAME)
			);
		query.exec("PRAGMA encoding =\"UTF-8\"");
		query.exec(QString("create index hashix on %1(hashId asc)").arg(PINYIN_DB_TABLENAME));
		//query.exec(QString("insert into pytable(word,pinyin,hashId) values('一','yi',%1)").arg(qhashEx("一",1)));
		query.clear();
		return true;

}
QString getPinyin(const char* s)
{
		QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "pinyindb");
		db.setDatabaseName(PINYIN_DB_FILENAME);	
		db.open();
		QSqlQuery q("",db);

		QString r=QString("select pinyin from %1 where hashId=%2 and word='%3' limit 1").arg(PINYIN_DB_TABLENAME).arg(qhashEx(s,1)).arg(s);

		if(q.exec(r)){					
			while(q.next()) { 
					qDebug()<<q.value(0).toString();	
			}
		}	
		db.close();
		QSqlDatabase::removeDatabase("pinyindb");
		return r;
}
int main(int argc, char *argv[])
{
		QStringList args = qApp->arguments();
		QApplication *app=new QApplication(argc, argv);
	    app->setQuitOnLastWindowClosed(true);
		//load db
#if 1
		QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", "pinyindb");
		db.setDatabaseName(PINYIN_DB_FILENAME);	
		db.open();
		createDbFile(db);
		importfile(db);
		db.close();
		QSqlDatabase::removeDatabase("pinyindb");
#else
		char *s ="";
		qDebug()<<getPinyin(s);
#endif
		//app->exec();
}
