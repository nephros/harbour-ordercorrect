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

#ifdef APP_VERSION
      app->setApplicationVersion(APP_VERSION);
#endif
    view->setSource(SailfishApp::pathToMainQml());
    view->show();
    return app->exec();
}
