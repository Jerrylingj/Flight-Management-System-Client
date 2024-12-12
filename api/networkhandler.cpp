#include "networkhandler.h"

// 实现

NetworkHandler::NetworkHandler(QObject *parent)
    : QObject(parent), m_NetworkHandler(new QNetworkAccessManager(this)) {
}
void NetworkHandler::request(const QString &url, RequestMethod method, const QJsonObject &data) {
    QNetworkRequest request;
    QNetworkReply *reply = nullptr;

    switch (method) {
    case GET: {
        QUrl fullUrl = buildUrlWithParams(url, data);
        request.setUrl(fullUrl);
        reply = m_NetworkHandler->get(request);
        break;
    }
    case POST: {
        request.setUrl(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        reply = m_NetworkHandler->post(request, QJsonDocument(data).toJson());
        break;
    }
    case PUT: {
        request.setUrl(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
        reply = m_NetworkHandler->put(request, QJsonDocument(data).toJson());
        break;
    }
    case DELETE: {
        request.setUrl(url);
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
