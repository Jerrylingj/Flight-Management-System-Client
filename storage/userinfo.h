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
    Q_PROPERTY(QString myToken READ myToken WRITE setMyToken NOTIFY myTokenChanged)
    Q_PROPERTY(QString userEmail READ userEmail WRITE setUserEmail NOTIFY userEmailChanged)
    Q_PROPERTY(QString myAvatar READ myAvatar WRITE setMyAvatar NOTIFY myAvatarChanged)
    Q_PROPERTY(QString myCreateTime READ myCreateTime WRITE setMyCreateTime NOTIFY myCreateTimeChanged)

public:
    explicit UserInfo(QObject *parent = nullptr) : QObject(parent), m_myMoney(0) {}

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

    QString myToken() const { return m_myToken; }
    void setMyToken(const QString &myToken) {
        if (m_myToken != myToken) {
            m_myToken = myToken;
            emit myTokenChanged();
        }
    }

    QString myAvatar() const {return m_myAvatar;}
    void setMyAvatar(const QString &avatar){
        if(m_myAvatar != avatar){
            m_myAvatar = avatar;
            emit myAvatarChanged();
        }
    }

    QString myCreateTime() const {return m_myCreateTime;}
    void setMyCreateTime(const QString &createTime){
        if(m_myCreateTime != createTime){
            m_myCreateTime = createTime;
            emit myCreateTimeChanged();
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

private:
    QString m_userName;
    QString m_userPersonalInfo;
    int m_myMoney;
    QString m_myTelephone;
    QString m_myToken;
    int m_userId;
    QString m_userEmail;
    QString m_myAvatar;
    QString m_myCreateTime;
};

#endif // USERINFO_H
