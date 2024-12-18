#ifndef MESSAGE_MANAGER_H
#define MESSAGE_MANAGER_H

#include <QObject>
#include <QStringList>
#include <QJsonObject>
#include <QJsonDocument>

class MessageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList messages READ messages NOTIFY messagesChanged)

public:

    QStringList messages() const
    {
        return m_messages;
    }

    void addMessage(const QJsonObject &messageObj)
    {
        // 创建一个可变的副本
        QJsonObject modifiableJsonObject = messageObj;
        // 将QJsonObject转为字符串
        modifiableJsonObject["timeStamp"] = QDateTime::currentDateTime().toString(Qt::ISODate);
        QJsonDocument jsonDoc(modifiableJsonObject);
        QString jsonString = jsonDoc.toJson(QJsonDocument::Compact);
        m_messages.append(jsonString);
    }

    QJsonObject StringToJson(const QString str)
    {
        QByteArray byteArray = QByteArray::fromBase64(str.toUtf8());

        // 将字符串转为QJsonObject
        QJsonDocument jsonDoc = QJsonDocument::fromJson(byteArray);
        QJsonObject jsonObject = jsonDoc.object();
        return jsonObject;
    }

signals:
    void messagesChanged();

private:
    QStringList m_messages;
};

#endif // MESSAGE_MANAGER_H
