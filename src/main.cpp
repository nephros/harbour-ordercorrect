// Copyright 2026 Peter G. <sailfish@nephros.org>
// SPDX-FileCopyrightText: 2026 Peter G. (nephros)
//
// SPDX-License-Identifier: Apache-2.0


#include <QQuickView>
#include <QScopedPointer>
#include <QtQuick>

#include <sailfishapp.h>

int main(int argc, char **argv) {

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

#ifndef APP_VERSION
#warn  "no version defined"
      app->setApplicationVersion("unreleased");
#else
      app->setApplicationVersion(APP_VERSION);
#endif
    //view->setSource(SailfishApp::pathToMainQml());
    view->setSource(QUrl("qrc:/qml/harbour-ordercorrect.qml"));
    view->show();
    return app->exec();
}
