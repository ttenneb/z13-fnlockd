Name:           z13-fnlockd
Version:        0.1.0
Release:        1%{?dist}
Summary:        Software Fn-lock daemon for ASUS ROG Flow Z13 GZ302

License:        MIT
URL:            https://github.com/ttenneb/z13-fnlockd
Source0:        %{url}/archive/refs/tags/v%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       python3
Requires:       python3-evdev
Requires:       libnotify
Recommends:     asusctl

BuildRequires:  systemd-rpm-macros
%{?systemd_requires}

%description
z13-fnlockd is a software Fn-lock daemon for the ASUS ROG Flow Z13 GZ302
keyboard cover on Linux.

The GZ302 keyboard cover exposes multiple HID interfaces. This daemon grabs only
the keyboard and consumer-key interfaces, avoids the touchpad/mouse interfaces,
and emits a virtual keyboard through uinput. Fn+Esc toggles a software Fn-lock
layer.

%prep
%autosetup

%build
# Nothing to build.

%install
install -D -m 0755 z13-fnlockd %{buildroot}%{_libexecdir}/z13-fnlockd
install -D -m 0644 z13-fnlockd.service %{buildroot}%{_unitdir}/z13-fnlockd.service
install -D -m 0644 README.md %{buildroot}%{_docdir}/%{name}/README.md
install -D -m 0644 LICENSE %{buildroot}%{_licensedir}/%{name}/LICENSE

%post
%systemd_post z13-fnlockd.service

%preun
%systemd_preun z13-fnlockd.service

%postun
%systemd_postun_with_restart z13-fnlockd.service

%files
%license LICENSE
%doc README.md
%{_libexecdir}/z13-fnlockd
%{_unitdir}/z13-fnlockd.service

%changelog
* Mon Jul 20 2026 Bennett Garcia <bennett.garcia@rutgers.edu> - 0.1.0-1
- Initial RPM package
