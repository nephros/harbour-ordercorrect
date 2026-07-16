# make clean
QMAKE_CLEAN += $${_PRO_FILE_PWD_}/debug*.list
QMAKE_CLEAN += $${_PRO_FILE_PWD_}/elfbins.list
QMAKE_CLEAN += $${_PRO_FILE_PWD_}/documentation.list
QMAKE_CLEAN += $${_PRO_FILE_PWD_}/build.log

# make distclean
# QMAKE_DISTCLEAN += -r $${_PRO_FILE_PWD_}/py/__pycache__

