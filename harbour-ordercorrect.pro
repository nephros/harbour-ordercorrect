TEMPLATE = app
TARGET = harbour-ordercorrect
CONFIG += sailfishapp
# add either the first, or both:
CONFIG += sailfishapp_i18n

# set this to NOT deploy the qml/ folder:
# CONFIG += sailfishapp_no_deploy_qml

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
