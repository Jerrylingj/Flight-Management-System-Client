#ifndef USERINFO_H
#define USERINFO_H

#include <QObject>
#include <QString>
#include <QJsonArray>
#include <QJsonObject>

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

public:
    explicit UserInfo(QObject *parent = nullptr)
        : QObject(parent), m_myMoney(0) {}

    // Existing getters and setters...

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

signals:
    void userEmailChanged();
    void userNameChanged();
    void userPersonalInfoChanged();
    void myMoneyChanged();
    void myTokenChanged();
    void myAvatarChanged();
    void myCreateTimeChanged();
    void myJsonArrayChanged();

private:
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
};

#endif // USERINFO_H
