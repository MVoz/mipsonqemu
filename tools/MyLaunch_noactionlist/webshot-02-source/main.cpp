/*
Ruzzz e-mail:ruzzzua@gmail.com 2009-10-30

TODO: Добавить возможность вырубатся по таймеру
TODO: Включить поддержку файла со списком сайтов
*/

#include <iostream>
#include <QtGui/QApplication>
#include <QFile>
#include "webshot.h"

int main(int argc, char *argv[])
{
    std::cout << "Ruzzz e-mail: ruzzzua@gmail.com 2009-10-30" << std::endl;
    std::cout << "Webshot v0.2 - Command line utility for capture and save shots of webpages" << std::endl;
    if (argc < 2) {
        std::cout << "Usage: " << argv[0] << " <url> [-r] [-n=shot.png] [-w=640] [-h=480]" << std::endl;
        std::cout << "-r - Rewrite file if exists;" << std::endl;
        std::cout << "n= - Filename of picture;" << std::endl;
        std::cout << "w= and h= - Width and height." << std::endl;
        std::cout << "for example: " << argv[0] << " http://google.com" << std::endl;
        return 1; // TODO Может добавить коды возврата для каждой ошибки?
    }

    QApplication app(argc, argv, true); // обязательно GUIenabled = true
    //QCoreApplication app(argc, argv);

    QString url = argv[1];

    QString filename = "shot.png";
    int width = -1;
    int height = -1;
    bool rewrite = false;

    // Можно оптимизировать, но оставлю так, для возможности добавления других ключей :)
    for (int i = 2; i < argc; i++) {        
        if (strcmp(argv[i], "-r") == 0) {
            rewrite = true;
            continue;
        }
        QString tStr = argv[i];
        int pos = tStr.indexOf("=") + 1;
        if (pos > 0) {
            //if (strncmp(argv[i], "-name=", 6) == 0) {
            if (tStr.startsWith("-n")) {
                filename = tStr.mid(pos);
                continue;
            }
            if (tStr.startsWith("-w")) {
                width = tStr.mid(pos).toInt();
                continue;
            }
            if (tStr.startsWith("-h")) {
                height = tStr.mid(pos).toInt();
                continue;
            }
        }
    }

    WebShot webshot;
    webshot.shot(url, filename, width, height, rewrite);

    return app.exec();
}
