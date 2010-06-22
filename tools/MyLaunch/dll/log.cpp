#include <log.h>
#include <QString>
#include <QStringList>
#include <QDir>
#include <windows.h>
#include <stdio.h>
#include <QFile>
#include <QTextStream>
#include <QDateTime>
#include <QMessageBox>
/*
void QDEBUG(const char *cformat, ...)
{

	va_list ap;
	va_start(ap, cformat);
	char msg[1024] = { 0 };
	vsnprintf(msg, sizeof(msg), cformat, ap);
	va_end(ap);
	qDebug(msg);

}
void logToFile(const char *cformat, ...)
{
		va_list ap;
		va_start(ap, cformat);
		QString msg;
		msg.vsprintf( cformat, ap);
		va_end(ap);
		//qDebug("msg=%s",qPrintable(msg));
		

	//va_list ap;
	//va_start(ap, cformat);
	//char msg[1024] = { 0 };
	//vsnprintf(msg, sizeof(msg), cformat, ap);
	//va_end(ap);
	QFile file("log11.txt");
	//QString msgstring(msg);
	file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append);
	QTextStream os(&file);
	os.setCodec("UTF-8");
	os << "[";
	os << QDateTime::currentDateTime().toString("hh:mm:ss");
	os << "] " << msg << "\n";
	file.close();
}
void logMsgbox(const char *cformat, ...)
{
	QMessageBox msgBox;
	va_list ap;
	va_start(ap, cformat);
	char msg[1024] = { 0 };
	vsnprintf(msg, sizeof(msg), cformat, ap);
	va_end(ap);
	QString msgstring(msg);
	msgBox.setText(msgstring);
	msgBox.exec();
}
*/
