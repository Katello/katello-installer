# Not building for scl rigth now
%undefine scl_prefix
%global scl_ruby /usr/bin/ruby

Name: node-installer
Version: 0.0.2
Release: 1%{?dist}
Summary: Puppet-based installer for the katello nodes
Group: Applications/System
License: GPLv3+ and ASL 2.0
URL: http://katello.org
Source0: %{name}-%{version}.tar.gz

BuildArch: noarch

Requires: %{?scl_prefix}rubygem-kafo

%description
Installer for Katello nodes.

%prep
%setup -q

%build
#replace shebangs
sed -ri '1sX(/usr/bin/ruby|/usr/bin/env ruby)X%{scl_ruby}X' bin/*

#configure the paths
sed -ri 'sX\./configX%{_sysconfdir}/%{name}Xg' bin/* config/*
sed -ri 'sX\:installer_dir.*$X:installer_dir: %{_datadir}/%{name}Xg' config/*

%install
install -d -m0755 %{buildroot}%{_sysconfdir}/%{name}
install -d -m0755 %{buildroot}/%{_datadir}/%{name}
install -d -m0755 %{buildroot}/%{_sbindir}
cp -dpR bin modules %{buildroot}/%{_datadir}/%{name}
cp -dpR config/* %{buildroot}/%{_sysconfdir}/%{name}
ln -sf %{_datadir}/%{name}/bin/node-install %{buildroot}/%{_sbindir}/node-install
ln -sf %{_datadir}/%{name}/bin/node-certs-generate %{buildroot}/%{_sbindir}/node-certs-generate

%files
%defattr(-,root,root,-)
%doc README.*
%{_datadir}/%{name}
%{_sysconfdir}/%{name}
%{_sbindir}/node-install
%{_sbindir}/node-certs-generate

%changelog
* Mon Sep 09 2013 Ivan Necas <inecas@redhat.com> 0.0.2-1
- Random password for the pulp admin (inecas@redhat.com)
- Validate params (inecas@redhat.com)
- Set up releasers (inecas@redhat.com)
- Set the zero exit code if everything's fine (inecas@redhat.com)

* Wed Sep 04 2013 Ivan Necas <inecas@redhat.com> 0.0.1-1
- new package built with tito

