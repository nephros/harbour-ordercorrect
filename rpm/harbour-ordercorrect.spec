Name:       harbour-ordercorrect

%bcond_with harbour

%define orgname org.nephros.sailfish
%define appname OrderMail
%define pkgname %{name}

%if %{with harbour}
%undefine vendor
%undefine _vendor
%undefine _chum
%endif

Summary:    Send Jolla Order Communication
Version:    0.1.4
Release:    0
Group:      Applications
License:    Apache-2.0
URL:        https://github.com/nephros/harbour-ordercorrect
Source0:    https://github.com/nephros/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
BuildRequires:  pkgconfig(sailfishapp)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  qt5-qmake
BuildRequires:  sailfish-svg2png
BuildRequires:  qml-rpm-macros
BuildRequires:  desktop-file-utils
%if 0%{?harbour_validation:1}
BuildRequires: sdk-harbour-rpmvalidator
%endif

%description
%{summary}.

A small helper application which allows sending email to Jolla Shop support in
a consistent way. This should help them to process the email queue efficiently.

Note that this is UNOFFICIAL and was not created by Jolla!

%if 0%{?_chum}
Title: OrderMail
Type: desktop-application
DeveloperName: Peter G.
Categories:
  - Utility
Custom:
  Repo: %{url}
PackageIcon: https://raw.githubusercontent.com/nephros/%{name}/refs/heads/master/%{name}.png
Screenshots:
 - https://raw.githubusercontent.com/nephros/%{name}/refs/heads/master/harbour-data/banner.png
 - https://raw.githubusercontent.com/nephros/%{name}/refs/heads/master/harbour-data/screenshot001.png
 - https://raw.githubusercontent.com/nephros/%{name}/refs/heads/master/harbour-data/screenshot002.png
%endif

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5  \
    VERSION='%{version}' \
    RELEASE='%{release}'

%make_build

%install
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%clean
%if 0%{?harbour_validation:1}
echo '=========== Checking for Harbour compatability.'
mkdir -p ~/rpmbuild/OTHER || :
find ~/rpmbuild/RPMS -type f -name %{name}-%{version}*.rpm -exec /usr/libexec/sdk-harbour-rpmvalidator/rpmvalidation.sh -d 0 --no-color {}  \; | tee ~/rpmbuild/OTHER/harbour-validator.log ||:
echo '=========== DONE checking for Harbour compatability.'
%else
echo '=========== NOT checking for Harbour compatability.'
%endif

%files
%{_bindir}/*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}/translations/harbour-ordercorrect-en.qm
# enable them once finished:
%{_datadir}/%{name}/translations/harbour-ordercorrect-de.qm
%exclude %{_datadir}/%{name}/translations/harbour-ordercorrect-fi.qm
%exclude %{_datadir}/%{name}/translations/harbour-ordercorrect-sv.qm

%{_datadir}/icons/hicolor/*/apps/%{name}.png
