QMAKE_EXTRA_TARGETS += lint
lint.commands = @echo "linting...";
lint.commands += echo "linting QML files..." && find qml/ -type f -name "*.qml" -exec qmllint {} +;
lint.commands += echo "linting Python files..." && find python/ -type f -name "*.py" -exec python3 -m py_compile {} \;;
lint.commands += echo "linting SPEC file..." && /opt/testing/usr/bin/rpmlint -P -r /opt/testing/etc/rpmlint/rpmlint-mini-rpmlintrc rpm/$${TARGET}.spec;

QMAKE_EXTRA_TARGETS += reuse
reuse.commands = @echo "checking REUSE compliance..." && reuse lint --lines

QMAKE_EXTRA_TARGETS += check-pre-build
check-pre-build.depends += lint reuse validate-desktop
check-pre-build.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += lint-rpm
lint-rpm.commands = @/opt/testing/usr/bin/rpmlint -P -r /opt/testing/etc/rpmlint/rpmlint-mini-rpmlintrc $$(BUILT_RPM) | tee validation.log
lint-rpm.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += validate-rpm
validate-rpm.commands = @/usr/libexec/sdk-harbour-rpmvalidator/rpmvalidation.sh $$(BUILT_RPM)
validate-rpm.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += validate-desktop
validate-desktop.commands = desktop-file-validate $${TARGET}.desktop
#validate-desktop.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += check-post-build
check-post-build.commands = @echo "Running post-build checks"
check-post-build.depends += validate-rpm lint-rpm
check.CONFIG += no_check_exist
