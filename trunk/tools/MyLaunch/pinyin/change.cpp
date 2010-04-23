#include <QApplication>
#include <QStringList>
#include <QFile>
#include <QString>
#include <QTextStream>
int main()
{
	QFile in("1.txt");
	QFile out("2.txt");
	in.open(QIODevice::ReadOnly | QIODevice::Text /*| QIODevice::Append*/);
	out.open(QIODevice::WriteOnly | QIODevice::Text /*| QIODevice::Append*/);
	QTextStream in_os(&in);
	QTextStream out_os(&out);
	in_os.setCodec("UTF-8");
	out_os.setCodec("UTF-8");
	while (!in.atEnd()) {
		QString line = QString::fromUtf8(in.readLine());
		QString linestr=QString("<<\"");
		linestr.append(line.at(0));
		linestr.append(line);
		out_os<<linestr;		
	}
}