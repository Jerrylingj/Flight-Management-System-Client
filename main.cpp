#include "api/networkhandler.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "storage/userinfo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/qt/Flight_Management_System_Client/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);
    qmlRegisterType<NetworkHandler>("NetworkHandler", 1, 0, "NetworkHandler");

    UserInfo userInfo;
    userInfo.setUserName("John Doe");
    userInfo.setUserPersonalInfo("Some personal info about John");
    userInfo.setMyMoney(1000);

    // 将 UserInfo 对象暴露给 QML
    engine.rootContext()->setContextProperty("userInfo", &userInfo);


    return app.exec();
}
