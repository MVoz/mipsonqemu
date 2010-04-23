/*
Ruzzz e-mail:ruzzzua@gmail.com 2009-10-30

Делаем так:
- Берем автоматически полученные размеры (content_width, content_height) c помощью m_page->mainFrame()->contentsSize();
- Пользователь явно задает размер эскиза (thumb_width, thumb_height), или ширину, или не задает :), только высоту не рассматриваем? :);
Далее определяем размеры окна рендеринга (view port):
- Если пользователь задал и ширину и высоту эскиза, то
  view_port_height = content_width * thumb_height / thumb_width, view_port_width = content_width, после рендера - image.scaled;
- Если задал только ширину, значит рендерим как есть view_port_width = content_width и тоже с высотой и делаем image.scaledToWidth;
- Ничего не задал, значит и рендерим и сохраняем как есть;
Но есть один момент, content_width, content_height могут быть определены WebKit'ом слишком маленькими,
- Поэтому задаем минимальные размеры, например 640x480;    // TODO:

- Если размер эскиза задан больше чем получено WebKit'ом, то корректируем размер окна для рендеринга и не делаем Scale!!!
TODO: Но тут проблема, если заданы только ширина или высота, и пусть мы присваеваем это значение для окна рендеринга, то как вычислить вторую величину? O_o

TODO:
Возможно лучше будет отказаться от QtGui и использовать не QApplication, а QCoreApplication
Для этого, возможно нужно не использовать QWebPage, а QWebFrame, но как создать этот QWebFrame?
В конструктор QWebFrame нужно передать QWebFrameData из qt\src\3rdparty\webkit\WebKit\qt\Api\qwebframe_p.h
QWebFrame и QWebFrameData могут помочь c определением размера фрейма

TODO: Проблемы с SSL
Например для "webshot habrahabr.ru" выдает:
QSslSocket: cannot call unresolved function SSLv3_client_method
QSslSocket: cannot call unresolved function SSL_CTX_new
QSslSocket: cannot call unresolved function SSL_library_init
QSslSocket: cannot call unresolved function ERR_get_error
QSslSocket: cannot call unresolved function ERR_error_string

TODO: Проблемы с какими-то шрифтами :)
Например для "webshot ya.ru" выдает:
QFontDatabase::load: Must construct QApplication first
QFontDatabase::load: Must construct QApplication first
*/

#include "webshot.h"
#include <iostream>
#include <QtCore/QCoreApplication>
#include <QtCore/QFile>
#include <QtCore/QFileInfo>
#include <QtWebKit/QWebPage>
#include <QtWebKit/QWebFrame>
#include <QtGui/QImage>
#include <QtGui/QPainter>

WebShot::WebShot()
{
    m_page = new QWebPage(0);

    connect(m_page, SIGNAL(loadFinished(bool)), SLOT(doShotOnPageLoaded(bool)));
    connect(m_page, SIGNAL(loadProgress(int)), SLOT(doShowProgress(int)));
}

// Взял из примера qt\demos\browser\browsermainwindow.cpp
// TODO: Почему не добавят в QUrl? :)
QUrl WebShot::guessUrlFromString(const QString &string)
{
    QString urlStr = string.trimmed();
    QRegExp test(QLatin1String("^[a-zA-Z]+\\:.*"));

    // Check if it looks like a qualified URL. Try parsing it and see.
    bool hasSchema = test.exactMatch(urlStr);
    if (hasSchema) {
        QUrl url = QUrl::fromEncoded(urlStr.toUtf8(), QUrl::TolerantMode);
        if (url.isValid())
            return url;
    }

    // Might be a file.
    if (QFile::exists(urlStr)) {
        QFileInfo info(urlStr);
        return QUrl::fromLocalFile(info.absoluteFilePath());
    }

    // Might be a shorturl - try to detect the schema.
    if (!hasSchema) {
        int dotIndex = urlStr.indexOf(QLatin1Char('.'));
        if (dotIndex != -1) {
            QString prefix = urlStr.left(dotIndex).toLower();
            QByteArray schema = (prefix == QLatin1String("ftp")) ? prefix.toLatin1() : "http";
            QUrl url =
                QUrl::fromEncoded(schema + "://" + urlStr.toUtf8(), QUrl::TolerantMode);
            if (url.isValid())
                return url;
        }
    }

    // Fall back to QUrl's own tolerant parser.
    QUrl url = QUrl::fromEncoded(string.toUtf8(), QUrl::TolerantMode);

    // finally for cases where the user just types in a hostname add http
    if (url.scheme().isEmpty())
        url = QUrl::fromEncoded("http://" + string.toUtf8(), QUrl::TolerantMode);
    return url;
}

void WebShot::shot(QString page, QString filename, int thumb_width, int thumb_height, bool rewrite)
{
    m_filename = filename;
    m_thumb_width = thumb_width;
    m_thumb_height = thumb_height;
    m_rewrite = rewrite; // TODO В начале конструктора :)

    QUrl url = guessUrlFromString(page);
    m_page->mainFrame()->load(url); //m_frame->load(url);
}

void WebShot::doShowProgress(int p)
{
    std::cout << "Loaded " << p << "%\r";
    std::cout.flush();
}

void WebShot::doShotOnPageLoaded(bool ok)
{
    if (!ok) {
        qCritical("Failed to load page");
        QCoreApplication::exit(1); // Останавливаем поток(и) запущеный WebKit'ом // TODO Иначе прога долго не закрывается. Решить!!!
        return;
    }

    std::cout << "Loading complete" << std::endl;

    // Определяем размер окна для рендеринга
    // Берем автоматически определенный размер    
    QSize view_port_size = m_page->mainFrame()->contentsSize();
    view_port_size.rwidth() += 10; // Исправляем баг с полосой прокрутки, похоже не всегда определяется верно ширина
    // На некоторых сайтах (например ya.ru) размер получается слишком маленький, поэтому задаем минимум
    if (view_port_size.width() < 640)
        view_port_size.rwidth() = 640;
    if (view_port_size.height() < 480)
        view_port_size.rheight() = 480;
    // Если задаем размер эскиза большим, то корректируем размер окна рендеринга
    // TODO: Правда тут проблема, как заставить WebKit пересчитать высоту (если она не задана) под новую ширину?
    if (view_port_size.width() < m_thumb_width)
        view_port_size.rwidth() = m_thumb_width;

    if (view_port_size.height() < m_thumb_height)
        view_port_size.rheight() = m_thumb_height;    
    // Если задали и ширину и высоту эскиза, то корректируем высоту окна для рендеринга
    else if (m_thumb_width != -1 && m_thumb_height != -1) {
        view_port_size.rheight() = view_port_size.width() * m_thumb_height / m_thumb_width;
    };
    m_page->setViewportSize(view_port_size);

    // Отключаем полосы прокрутки
    // TODO: Тут какой-то баг - можем отключить лишь одну из полос, ту которую отключаем последеней :(
    //   Но проявляется лишь в некоторых случаях, похоже мне удалось их обойти? :)
    m_page->mainFrame()->setScrollBarPolicy(Qt::Horizontal, Qt::ScrollBarAlwaysOff);
    m_page->mainFrame()->setScrollBarPolicy(Qt::Vertical, Qt::ScrollBarAlwaysOff);

    QImage image(m_page->viewportSize(), QImage::Format_ARGB32);
    QPainter painter(&image);    
    m_page->mainFrame()->render(&painter); //m_frame->render(&painter);
    painter.end();    

    if (QFile::exists(m_filename)) {
        if (!m_rewrite) { // Если не перезаписываем, то создаем имя с помощью счетчика
            int j = 1;
            QFileInfo fi(m_filename);
            QString temp_name;
            do {
                temp_name = fi.baseName() + QString::number(j++) + "." + fi.completeSuffix();
            } while (QFile::exists(temp_name));
            m_filename = temp_name;
        }
        //else QFile::remove(m_filename); // И так переписывает :)
    }

    // Определяем размер картинки "эскиза" для сохранения в файле
    // Если не заданы ширина и высота, то сохраняем "как есть", т.е. так как определил WebKit    
    // Если задана ширина и/или высота, то изменяем размер изображения сохраняя пропорции.
    QImage thumb;
    if (m_thumb_width != -1 && m_thumb_height != -1) {
        thumb = image.scaled(m_thumb_width, m_thumb_height, Qt::KeepAspectRatio, Qt::SmoothTransformation);
    } else if (m_thumb_width != -1) {
        thumb = image.scaledToWidth(m_thumb_width, Qt::SmoothTransformation);
    } else if (m_thumb_height != -1) {
        thumb = image.scaledToHeight(m_thumb_height, Qt::SmoothTransformation);
    } else
        thumb = image;

    if (!thumb.save(m_filename)) {
        QString err = "Failed to save image to " + m_filename;
        qCritical(err.toAscii());
        QCoreApplication::exit(1); // Останавливаем поток(и) запущеный WebKit'ом
        return;
    }
    std::cout << "Saved to " << m_filename.toAscii().data() << std::endl;
    std::cout << "Operation complete" << std::endl;
    QCoreApplication::quit(); // Останавливаем поток(и) запущеный WebKit'ом
}
