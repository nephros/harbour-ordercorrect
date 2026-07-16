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
    qml/components/*.qml

}

# if we have a binary:
#INCLUDEPATH += .
SOURCES += src/main.cpp

TRANSLATIONS += translations/$${TARGET}-en.ts \
                translations/$${TARGET}-de.ts \
                translations/$${TARGET}-sv.ts

# sailfishapp should take care of this:
# desktop.files = $${TARGET}.desktop
# desktop.path = $$PREFIX/share/applications
# INSTALLS += desktop

mydesktop.files += desktop/$${TARGET}.desktop
#mydesktop.files += desktop/$${TARGET}-openUrl.desktop
#mydesktop.files += desktop/$${TARGET}-share.desktop
mydesktop.path = $$PREFIX/share/applications
INSTALLS += mydesktop

# qml.files = qml
# qml.path = $$PREFIX/share/$${TARGET}
# INSTALLS += qml


QMAKE_EXTRA_TARGETS += documentation
documentation.commands = doxygen tools/doxygen/$${TARGET}.doxyfile
#documentation.commands = tools/makedocs

QMAKE_EXTRA_TARGETS += ts
ts.commands = lupdate $$_PRO_FILE_

# sailfishapp has this already:
OTHER_FILES += $$files(rpm/*)

OTHER_FILES += $$files(desktop/*)

# NOTE: do not include TEMPLATE declarations in .pro files!
include(translations/translations.pri)
i#include(icons/icons.pri)
include(check.pri)
include(clean.pri)
