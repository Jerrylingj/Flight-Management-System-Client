#ifndef USERINFO_H
#define USERINFO_H

#include <QObject>
#include <QString>

class UserInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString userName READ userName WRITE setUserName NOTIFY userNameChanged)
    Q_PROPERTY(QString userPersonalInfo READ userPersonalInfo WRITE setUserPersonalInfo NOTIFY userPersonalInfoChanged)
    Q_PROPERTY(int myMoney READ myMoney WRITE setMyMoney NOTIFY myMoneyChanged)
    Q_PROPERTY(QString myTelephone READ myTelephone WRITE setMyTelephone NOTIFY myTelephoneChanged)
    Q_PROPERTY(QString myToken READ myToken WRITE setMyToken NOTIFY myTokenChanged)
    Q_PROPERTY(int userId READ userId WRITE setUserId NOTIFY userIdChanged)
    Q_PROPERTY(QString userEmail READ userEmail WRITE setUserEmail NOTIFY userEmailChanged)

public:
    explicit UserInfo(QObject *parent = nullptr) : QObject(parent), m_myMoney(0) {}

    int userId() const { return m_userId; }
    void setUserId(int userId) {
        if (m_userId != userId) {
            m_userId = userId;
            emit userIdChanged();
        }
    }

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

    int myMoney() const { return m_myMoney; }
    void setMyMoney(int myMoney) {
        if (m_myMoney != myMoney) {
            m_myMoney = myMoney;
            emit myMoneyChanged();
        }
    }

    QString myTelephone() const { return m_myTelephone; }
    void setMyTelephone(const QString &myTelephone) {
        if (m_myTelephone != myTelephone) {
            m_myTelephone = myTelephone;
            emit myTelephoneChanged();
        }
    }

    QString myToken() const { return m_myToken; }
    void setMyToken(const QString &myToken) {
        if (m_myToken != myToken) {
            m_myToken = myToken;
            emit myTokenChanged();
        }
    }

signals:
    void userIdChanged();
    void userEmailChanged();
    void userNameChanged();
    void userPersonalInfoChanged();
    void myMoneyChanged();
    void myTelephoneChanged();
    void myTokenChanged();

private:
    QString m_userName;
    QString m_userPersonalInfo;
    int m_myMoney;
    QString m_myTelephone;
    QString m_myToken;
    int m_userId;
    QString m_userEmail;
};

#endif // USERINFO_H
