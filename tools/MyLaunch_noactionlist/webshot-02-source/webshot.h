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
    void shot(QString page, QString filename, int thumb_width, int thumb_height, bool rewrite); // Делает снимок страницы =)
    static QUrl guessUrlFromString(const QString &url); // Пытается получить правильный url из строки

protected slots:
    void doShotOnPageLoaded(bool); // Выполняется по событию "Оперция загрузки страницы завершена"
    void doShowProgress(int p);

private:
    QString m_filename; // Имя файла картинки, куда сохраним изображение страницы
                        // TODO: Проверять существует ли каталог, если нет то создаем всю иерархию

    int m_thumb_width; // Размеры "эскиза"
    int m_thumb_height;

    bool m_rewrite; // Переписывать ли файл если с таким именем уже есть

    QWebPage *m_page;
};

#endif // WEBSHOT_H
