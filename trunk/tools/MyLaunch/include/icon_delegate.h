#ifndef ICON_DELEGATE_H_
#define ICON_DELEGATE_H_
#include <globals.h>
#include <config.h>

#include <windows.h>
#include <bmapi.h>
#include <QColor>
#include <QPainter>
#include <QStyleOptionViewItem>
#include <QModelIndex>
#include <QAbstractItemDelegate>

#define ROLE_FULL Qt::UserRole
#define ROLE_SHORT Qt::UserRole + 1
#define ROLE_ICON Qt::UserRole + 2
#if defined(ICON_DELEGATE)
#define ICON_DELEGATE_CLASS_EXPORT __declspec(dllexport)
#else
#define ICON_DELEGATE_CLASS_EXPORT __declspec(dllimport)
//#define ICON_DELEGATE_CLASS_EXPORT 
#endif
class ICON_DELEGATE_CLASS_EXPORT IconDelegate : public QAbstractItemDelegate
{
	Q_OBJECT

private:
	QColor color;
	QColor hicolor;
	QString family;
	int size;
	int weight;
	int italics;

public:

	IconDelegate(QObject *parent = 0);

	void paint(QPainter *painter, const QStyleOptionViewItem &option,
		const QModelIndex &index) const;

	QSize sizeHint(const QStyleOptionViewItem &option,
		const QModelIndex &index ) const;

	void setColor(QString line, bool hi = false) {
		if (!line.contains(","))
			color = QColor(line);

		QStringList spl = line.split(",");
		if (spl.count() != 3) return;
		if (!hi)
			color = QColor(spl.at(0).toInt(), spl.at(1).toInt(), spl.at(2).toInt());
		else
			hicolor = QColor(spl.at(0).toInt(), spl.at(1).toInt(), spl.at(2).toInt());
	}

	void setFamily(QString fam) { family = fam; }
	void setSize(int s) { size = s; }
	void setWeight(int w) { weight = w; }
	void setItalics(int i) { italics = i; }
};
#endif
