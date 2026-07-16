TEMPLATE = app
TARGET = harbour-ordercorrect
CONFIG += sailfishapp
CONFIG += sailfishapp_i18n

QT -= gui


lupdate_only {
SOURCES += \
    qml/$${TARGET}.qml \
    qml/pages/*.qml \
    qml/cover/*.qml \

}

# if we have a binary:
INCLUDEPATH += .
SOURCES += src/main.cpp

TRANSLATIONS += translations/$${TARGET}-en.ts \
                translations/$${TARGET}-de.ts \
                translations/$${TARGET}-sv.ts


QMAKE_EXTRA_TARGETS += ts
ts.commands = lupdate $$_PRO_FILE_

# sailfishapp has this already:
OTHER_FILES += $$files(rpm/*)

#include(icons/icons.pri)
include(check.pri)
include(clean.pri)
