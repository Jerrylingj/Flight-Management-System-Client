#include "networkhandler.h"

// 实现

NetworkHandler::NetworkHandler(QObject *parent, QString api_url)
    : QObject(parent), m_NetworkHandler(new QNetworkAccessManager(this)), api_url(api_url) {
}
void NetworkHandler::request(const QString &url, RequestMethod method, const QJsonObject &data, const QString Token) {
    QNetworkRequest request;
    QNetworkReply *reply = nullptr;

    QString finalUrl = url;
    if(url.startsWith("/")){
        finalUrl = api_url + url;
    }

    // qDebug() << finalUrl;

    // 如果 token 不为空，则将其添加到请求头的 Authorization 字段，格式为 Bearer <token>
    if (!Token.isEmpty()) {
        request.setRawHeader("Authorization", QString("Bearer %1").arg(Token).toUtf8());
    }

    switch (method) {
    case GET: {
        QUrl fullUrl = buildUrlWithParams(finalUrl, data);
        request.setUrl(fullUrl);
        reply = m_NetworkHandler->get(request);
        break;
    }
    case POST: {
        request.setUrl(finalUrl);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        reply = m_NetworkHandler->post(request, QJsonDocument(data).toJson());
        break;
    }
    case PUT: {
        request.setUrl(finalUrl);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        reply = m_NetworkHandler->put(request, QJsonDocument(data).toJson());
        break;
    }
    case DELETE: {
        request.setUrl(finalUrl);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        reply = m_NetworkHandler->deleteResource(request);
        break;
    }
    }

    connect(reply, &QNetworkReply::finished, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            emit requestSuccess(doc.object());
        } else {
            emit requestFailed(reply->errorString());
        }
        reply->deleteLater();
    });
}

QUrl NetworkHandler::buildUrlWithParams(const QString &baseUrl, const QJsonObject &params) {
    QUrl url(baseUrl);
    QUrlQuery query;

    for (auto it = params.begin(); it != params.end(); ++it) {
        query.addQueryItem(it.key(), it.value().toString());
    }

    url.setQuery(query);
    return url;
}
