TEMPLATE = app
TARGET = harbour-ordercorrect

QT -= gui

CONFIG += sailfishapp
CONFIG += sailfishapp_i18n
CONFIG += sailfishapp_no_deploy_qml

# if we have a binary:
INCLUDEPATH += .
SOURCES += src/main.cpp

QML_FILES += \
    qml/$${TARGET}.qml \
    qml/pages/*.qml \
    qml/cover/*.qml
RESOURCES += qml.qrc

TRANSLATIONS += translations/$${TARGET}-en.ts \
                translations/$${TARGET}-de.ts \
                translations/$${TARGET}-fi.ts \
                translations/$${TARGET}-sv.ts

QMAKE_EXTRA_TARGETS += ts
ts.commands = lupdate $$_PRO_FILE_

# sailfishapp has this already:
OTHER_FILES += $$files(rpm/*)

#include(icons/icons.pri)
include(check.pri)
include(clean.pri)
