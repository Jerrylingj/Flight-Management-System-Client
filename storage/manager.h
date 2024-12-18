#ifndef MESSAGEMANAGER_H
#define MESSAGEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QQmlApplicationEngine>

class MessageManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList messages READ messages CONSTANT)

public:
    // 单例模式获取实例
    static MessageManager* instance();

    QVariantList messages() const;

private:
    explicit MessageManager(QObject *parent = nullptr);

    static MessageManager* m_instance;
    QVariantList m_messages;
};

#endif // MESSAGEMANAGER_H

// 下面是类成员函数的定义

#include "MessageManager.h"

MessageManager* MessageManager::m_instance = nullptr;

MessageManager* MessageManager::instance()
{
    if (!m_instance)
        m_instance = new MessageManager();
    return m_instance;
}

MessageManager::MessageManager(QObject *parent)
    : QObject(parent), m_messages({
          QVariantMap{{"role", "system"}, {"content", "你是一个航班信息管理系统的客服，你可以查询航班信息。你需要准确地回答客户，如果你不知道你应该直接回答不知道而不是编造一条数据"}}
      })
{}

QVariantList MessageManager::messages() const
{
    return m_messages;
}
