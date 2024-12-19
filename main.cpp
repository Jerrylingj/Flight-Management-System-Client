#include "api/networkhandler.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "storage/userinfo.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;


    // 初始化 NetworkHandler
    NetworkHandler networkHandler(nullptr);

    // 初始化 UserInfo 并传递 NetworkHandler
    UserInfo userInfo(&networkHandler);
    userInfo.setUserName("旅客");
    userInfo.setUserPersonalInfo("普通的旅客");
    userInfo.setMyMoney(-1);
    userInfo.setUserEmail("noname@mail2.sysu.edu.cn");
    userInfo.setMyAvatar("qrc:/qt/Flight_Management_System_Client/figures/avatar.jpg");

    // 将 UserInfo 对象暴露给 QML
    engine.rootContext()->setContextProperty("userInfo", &userInfo);

    const QUrl url(u"qrc:/qt/Flight_Management_System_Client/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);
    qmlRegisterType<NetworkHandler>("NetworkHandler", 1, 0, "NetworkHandler");

    return app.exec();
}
