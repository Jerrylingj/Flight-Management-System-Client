#ifndef USERINFO_H
#define USERINFO_H

#include <QObject>
#include <QString>
#include <QJsonArray>
#include <QJsonObject>
#include "api\networkhandler.h"

class UserInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString userPersonalInfo READ userPersonalInfo WRITE setUserPersonalInfo NOTIFY userPersonalInfoChanged)
    Q_PROPERTY(double myMoney READ myMoney WRITE setMyMoney NOTIFY myMoneyChanged)
    Q_PROPERTY(QString myToken READ myToken WRITE setMyToken NOTIFY myTokenChanged)
    Q_PROPERTY(QString userEmail READ userEmail WRITE setUserEmail NOTIFY userEmailChanged)
    Q_PROPERTY(QString myAvatar READ myAvatar WRITE setMyAvatar NOTIFY myAvatarChanged)
    Q_PROPERTY(QString myCreateTime READ myCreateTime WRITE setMyCreateTime NOTIFY myCreateTimeChanged)
    Q_PROPERTY(QJsonArray myJsonArray READ myJsonArray NOTIFY myJsonArrayChanged)
    Q_PROPERTY(QString authCode READ authCode WRITE setAuthCode NOTIFY authCodeChanged)

public:
    // 构造函数增加 NetworkHandler 参数
    explicit UserInfo(NetworkHandler* networkHandler, QObject *parent = nullptr)
        : QObject(parent), m_myMoney(0), m_networkHandler(networkHandler)
    {
        // 连接网络请求的信号到槽函数
        connect(m_networkHandler, &NetworkHandler::requestSuccess, this, &UserInfo::onRequestSuccess);
        connect(m_networkHandler, &NetworkHandler::requestFailed, this, &UserInfo::onRequestFailed);
    }

    // 声明 updateUserInfo 函数
    Q_INVOKABLE void updateUserInfo();

    QString userEmail() const { return m_userEmail; }
    void setUserEmail(const QString &userEmail) {
        if (m_userEmail != userEmail) {
            m_userEmail = userEmail;
            emit userEmailChanged();
        }
    }

    QString userName() const { return m_userName; }
    void setUserName(const QString &userName) {
        if (m_userName != userName) {
            m_userName = userName;
            emit userNameChanged();
        }
    }

    QString userPersonalInfo() const { return m_userPersonalInfo; }
    void setUserPersonalInfo(const QString &userPersonalInfo) {
        if (m_userPersonalInfo != userPersonalInfo) {
            m_userPersonalInfo = userPersonalInfo;
            emit userPersonalInfoChanged();
        }
    }

    double myMoney() const { return m_myMoney; }
    void setMyMoney(double myMoney) { // 修改返回类型为 double
        if (!qFuzzyCompare(m_myMoney, myMoney)) {
            m_myMoney = myMoney;
            emit myMoneyChanged();
        }
    }

    QString myToken() const { return m_myToken; }
    void setMyToken(const QString &myToken) {
        if (m_myToken != myToken) {
            m_myToken = myToken;
            emit myTokenChanged();
        }
    }

    QString myAvatar() const { return m_myAvatar; }
    void setMyAvatar(const QString &avatar){
        if(m_myAvatar != avatar){
            m_myAvatar = avatar;
            emit myAvatarChanged();
        }
    }

    QString myCreateTime() const { return m_myCreateTime; }
    void setMyCreateTime(const QString &createTime){
        if(m_myCreateTime != createTime){
            m_myCreateTime = createTime;
            emit myCreateTimeChanged();
        }
    }

    // 新增的 QJsonArray getter
    QJsonArray myJsonArray() const { return m_myJsonArray; }

    // 新增的 Q_INVOKABLE 方法，用于在 QML 中添加元素
    Q_INVOKABLE void appendToMyJsonArray(const QVariantMap &item) {
        QJsonObject jsonObj = QJsonObject::fromVariantMap(item);
        m_myJsonArray.append(jsonObj);
        emit myJsonArrayChanged();
    }

    QString authCode() const { return m_authCode; }
    void setAuthCode(const QString& authCode){
        if(m_authCode != authCode){
            m_authCode = authCode;
            emit authCodeChanged();
        }
    }

signals:
    void userEmailChanged();
    void userNameChanged();
    void userPersonalInfoChanged();
    void myMoneyChanged();
    void myTokenChanged();
    void myAvatarChanged();
    void myCreateTimeChanged();
    void myJsonArrayChanged();
    void authCodeChanged();

private slots:
    // 槽函数用于处理网络请求成功
    void onRequestSuccess(const QJsonObject &response);

    // 槽函数用于处理网络请求失败
    void onRequestFailed(const QString &error);

private:
    NetworkHandler* m_networkHandler; // 新增的 NetworkHandler 成员变量
    QString m_userName;
    QString m_userPersonalInfo;
    double m_myMoney;
    QString m_myTelephone;
    QString m_myToken;
    int m_userId;
    QString m_userEmail;
    QString m_myAvatar;
    QString m_myCreateTime;
    QJsonArray m_myJsonArray; // 新增的成员变量
    QString m_authCode;
};

inline void UserInfo::updateUserInfo() {
    QJsonObject requestData;
    // 根据API需求添加必要的参数，例如用户ID等
    // requestData.insert("userId", m_userId);

    // 定义用于获取用户信息的API端点
    QString url = "/api/user"; // 替换为实际的API端点
    qDebug() << "已发送更新用户信息的请求";

    // 发送GET请求，假设获取用户信息的API使用GET方法
    m_networkHandler->request(url, NetworkHandler::GET, requestData, m_myToken);
}

inline void UserInfo::onRequestSuccess(const QJsonObject &response) {
    // 将 response 转换为格式化的 JSON 字符串并输出
    QJsonDocument doc(response);
    QString jsonString = doc.toJson(QJsonDocument::Indented);
    qDebug() << "Received response:" << jsonString;

    // 检查响应码是否为 200
    if (response.contains("code") && response["code"].toInt() == 200) {
        // 获取 data 对象
        QJsonObject data = response["data"].toObject();

        // 更新用户名
        // if (data.contains("username")) {
        //     qDebug() << "更新用户姓名";
        //     setUserName(data["username"].toString());
        // }

        // 更新用户邮箱
        // if (data.contains("email")) {
        //     qDebug() << "更新用户邮箱";
        //     setUserEmail(data["email"].toString());
        // }

        // 更新用户余额
        if (data.contains("balance")) {
            qDebug() << "更新用户余额";
            setMyMoney(data["balance"].toDouble());
        }

        // 更新用户创建时间
        // if (data.contains("created_at")) {
        //     qDebug() << "更新用户创建时间";
        //     setMyCreateTime(data["created_at"].toString());
        // }

        // 更新用户头像（暂时注释掉）
        /*
        if (data.contains("avatar_url")) {
            qDebug() << "更新用户头像";
            setMyAvatar(data["avatar_url"].toString());
        }
        */
    } else {
        // 如果响应码不是 200，输出错误信息
        if (response.contains("message")) {
            qWarning() << "更新用户信息失败:" << response["message"].toString();
        } else {
            qWarning() << "更新用户信息失败: 未知错误";
        }
        return; // 早期返回，避免继续执行
    }

    qDebug() << "已成功更新用户信息";
}


inline void UserInfo::onRequestFailed(const QString &error) {
    qWarning() << "Failed to update user info:" << error;
}

#endif // USERINFO_H
