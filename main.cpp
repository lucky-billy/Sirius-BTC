#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQuickView *view = new QQuickView;
    view->rootContext()->setContextProperty("mainwindow", view);
    view->setSource(QUrl("qrc:/main.qml"));
    view->show();
    return app.exec();
}
