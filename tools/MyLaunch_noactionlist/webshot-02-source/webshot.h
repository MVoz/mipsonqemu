/*
Ruzzz e-mail:ruzzzua@gmail.com 2009-10-30
*/

#ifndef WEBSHOT_H
#define WEBSHOT_H

#include <QtCore/QObject>
#include <QtCore/QSize>
#include <QtCore/QUrl>
#include <QtGui/QWidget>

class QWebPage;

class WebShot : public QWidget//QObject
{
Q_OBJECT

public:
    WebShot(); //test
    void shot(QString page, QString filename, int thumb_width, int thumb_height, bool rewrite); // ������ ������ �������� =)
    static QUrl guessUrlFromString(const QString &url); // �������� �������� ���������� url �� ������

protected slots:
    void doShotOnPageLoaded(bool); // ����������� �� ������� "������� �������� �������� ���������"
    void doShowProgress(int p);

private:
    QString m_filename; // ��� ����� ��������, ���� �������� ����������� ��������
                        // TODO: ��������� ���������� �� �������, ���� ��� �� ������� ��� ��������

    int m_thumb_width; // ������� "������"
    int m_thumb_height;

    bool m_rewrite; // ������������ �� ���� ���� � ����� ������ ��� ����

    QWebPage *m_page;
};

#endif // WEBSHOT_H
