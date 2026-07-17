Name:       harbour-ordercorrect

%define orgname org.nephros.sailfish
%define appname OrderMail
%define pkgname %{name}

%undefine vendor
%undefine _vendor
%undefine _chum

Summary:    Jolla Order Correction Helper
Version:    0.1.0
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

# as we build the qml files int the binary, we need to require stuff here:
Requires: qml(Nemo.Notifications)
Requires: qml(Sailfish.Silica)
Requires: qml(Nemo.Configuration)

%description
%{summary}.


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
%{_datadir}/%{name}/translations/*.qm
%{_datadir}/icons/hicolor/*/apps/%{name}.png
