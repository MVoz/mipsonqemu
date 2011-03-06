/*
Ruzzz e-mail:ruzzzua@gmail.com 2009-10-30

������ ���:
- ����� ������������� ���������� ������� (content_width, content_height) c ������� m_page->mainFrame()->contentsSize();
- ������������ ���� ������ ������ ������ (thumb_width, thumb_height), ��� ������, ��� �� ������ :), ������ ������ �� �������������? :);
����� ���������� ������� ���� ���������� (view port):
- ���� ������������ ����� � ������ � ������ ������, ��
  view_port_height = content_width * thumb_height / thumb_width, view_port_width = content_width, ����� ������� - image.scaled;
- ���� ����� ������ ������, ������ �������� ��� ���� view_port_width = content_width � ���� � ������� � ������ image.scaledToWidth;
- ������ �� �����, ������ � �������� � ��������� ��� ����;
�� ���� ���� ������, content_width, content_height ����� ���� ���������� WebKit'�� ������� ����������,
- ������� ������ ����������� �������, �������� 640x480;    // TODO:

- ���� ������ ������ ����� ������ ��� �������� WebKit'��, �� ������������ ������ ���� ��� ���������� � �� ������ Scale!!!
TODO: �� ��� ��������, ���� ������ ������ ������ ��� ������, � ����� �� ����������� ��� �������� ��� ���� ����������, �� ��� ��������� ������ ��������? O_o

TODO:
�������� ����� ����� ���������� �� QtGui � ������������ �� QApplication, � QCoreApplication
��� �����, �������� ����� �� ������������ QWebPage, � QWebFrame, �� ��� ������� ���� QWebFrame?
� ����������� QWebFrame ����� �������� QWebFrameData �� qt\src\3rdparty\webkit\WebKit\qt\Api\qwebframe_p.h
QWebFrame � QWebFrameData ����� ������ c ������������ ������� ������

TODO: �������� � SSL
�������� ��� "webshot habrahabr.ru" ������:
QSslSocket: cannot call unresolved function SSLv3_client_method
QSslSocket: cannot call unresolved function SSL_CTX_new
QSslSocket: cannot call unresolved function SSL_library_init
QSslSocket: cannot call unresolved function ERR_get_error
QSslSocket: cannot call unresolved function ERR_error_string

TODO: �������� � ������-�� �������� :)
�������� ��� "webshot ya.ru" ������:
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

// ���� �� ������� qt\demos\browser\browsermainwindow.cpp
// TODO: ������ �� ������� � QUrl? :)
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
    m_rewrite = rewrite; // TODO � ������ ������������ :)

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
        QCoreApplication::exit(1); // ������������� �����(�) ��������� WebKit'�� // TODO ����� ����� ����� �� �����������. ������!!!
        return;
    }

    std::cout << "Loading complete" << std::endl;

    // ���������� ������ ���� ��� ����������
    // ����� ������������� ������������ ������    
    QSize view_port_size = m_page->mainFrame()->contentsSize();
    view_port_size.rwidth() += 10; // ���������� ��� � ������� ���������, ������ �� ������ ������������ ����� ������
    // �� ��������� ������ (�������� ya.ru) ������ ���������� ������� ���������, ������� ������ �������
    if (view_port_size.width() < 640)
        view_port_size.rwidth() = 640;
    if (view_port_size.height() < 480)
        view_port_size.rheight() = 480;
    // ���� ������ ������ ������ �������, �� ������������ ������ ���� ����������
    // TODO: ������ ��� ��������, ��� ��������� WebKit ����������� ������ (���� ��� �� ������) ��� ����� ������?
    if (view_port_size.width() < m_thumb_width)
        view_port_size.rwidth() = m_thumb_width;

    if (view_port_size.height() < m_thumb_height)
        view_port_size.rheight() = m_thumb_height;    
    // ���� ������ � ������ � ������ ������, �� ������������ ������ ���� ��� ����������
    else if (m_thumb_width != -1 && m_thumb_height != -1) {
        view_port_size.rheight() = view_port_size.width() * m_thumb_height / m_thumb_width;
    };
    m_page->setViewportSize(view_port_size);

    // ��������� ������ ���������
    // TODO: ��� �����-�� ��� - ����� ��������� ���� ���� �� �����, �� ������� ��������� ���������� :(
    //   �� ����������� ���� � ��������� �������, ������ ��� ������� �� ������? :)
    m_page->mainFrame()->setScrollBarPolicy(Qt::Horizontal, Qt::ScrollBarAlwaysOff);
    m_page->mainFrame()->setScrollBarPolicy(Qt::Vertical, Qt::ScrollBarAlwaysOff);

    QImage image(m_page->viewportSize(), QImage::Format_ARGB32);
    QPainter painter(&image);    
    m_page->mainFrame()->render(&painter); //m_frame->render(&painter);
    painter.end();    

    if (QFile::exists(m_filename)) {
        if (!m_rewrite) { // ���� �� ��������������, �� ������� ��� � ������� ��������
            int j = 1;
            QFileInfo fi(m_filename);
            QString temp_name;
            do {
                temp_name = fi.baseName() + QString::number(j++) + "." + fi.completeSuffix();
            } while (QFile::exists(temp_name));
            m_filename = temp_name;
        }
        //else QFile::remove(m_filename); // � ��� ������������ :)
    }

    // ���������� ������ �������� "������" ��� ���������� � �����
    // ���� �� ������ ������ � ������, �� ��������� "��� ����", �.�. ��� ��� ��������� WebKit    
    // ���� ������ ������ �/��� ������, �� �������� ������ ����������� �������� ���������.
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
        QCoreApplication::exit(1); // ������������� �����(�) ��������� WebKit'��
        return;
    }
    std::cout << "Saved to " << m_filename.toAscii().data() << std::endl;
    std::cout << "Operation complete" << std::endl;
    QCoreApplication::quit(); // ������������� �����(�) ��������� WebKit'��
}
