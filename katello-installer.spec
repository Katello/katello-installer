# Not building for scl rigth now
%undefine scl_prefix
%global scl_ruby /usr/bin/ruby

Name: katello-installer
Version: 0.0.18
Release: 1%{?dist}
Summary: Puppet-based installer for the Katello and Katello Nodes
Group: Applications/System
License: GPLv3+ and ASL 2.0
URL: http://katello.org
Source0: %{name}-%{version}.tar.gz

BuildArch: noarch

Requires: %{?scl_prefix}rubygem-kafo
Requires:   %{?scl_prefix}rubygem-foreman_api >= 0.1.4

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
%dir %{_sysconfdir}/%{name}
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.certs.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.node.yaml
%config %{_sysconfdir}/%{name}/config_header.txt
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/kafo.certs.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/kafo.node.yaml
%{_sbindir}/node-install
%{_sbindir}/node-certs-generate

%changelog
* Tue Oct 22 2013 Unknown name <inecas@redhat.com> 0.0.18-1
- 1021119 - make sure private keys are never world readable (inecas@redhat.com)
- Document the parameters of the pulp class (shk@redhat.com)
- 1020975 - do not create node cert repos with a url (jsherril@redhat.com)

* Tue Oct 15 2013 Ivan Necas <inecas@redhat.com>
- Update foreman puppet modules (inecas@redhat.com)
- 1017449: Updating pulp server.conf (daviddavis@redhat.com)

* Fri Oct 11 2013 Unknown name <inecas@redhat.com> 0.0.16-1
- 1017074 - correctly set the flags for config files in spec
  (inecas@redhat.com)
- Update the modules to Foreman 1.3-rc4 (inecas@redhat.com)

* Wed Oct 02 2013 Ivan Necas <inecas@redhat.com> 0.0.15-1
- Merge pull request #2 from domcleal/tftp_servername (inecas@redhat.com)
- 975166 - expose tftp_servername (dcleal@redhat.com)
- Fix indentation (dcleal@redhat.com)

* Wed Oct 02 2013 Ivan Necas <inecas@redhat.com> 0.0.14-1
- Install pulp-puppet-plugins to support puppet content on child
  (inecas@redhat.com)

* Wed Oct 02 2013 Ivan Necas <inecas@redhat.com> 0.0.13-1
- Properly set the owner for /etc/puppet/environments (inecas@redhat.com)

* Fri Sep 27 2013 Ivan Necas <inecas@redhat.com> 0.0.12-1
- Make sure goferd is restarted when server.conf changes (inecas@redhat.com)

* Fri Sep 27 2013 Ivan Necas <inecas@redhat.com> 0.0.11-1
- Update the configuration for pulp-2.3 (inecas@redhat.com)

* Tue Sep 24 2013 Ivan Necas <inecas@redhat.com> 0.0.10-1
- 1009964 - Revert "Workaround for #3080 - install foreman-selinux whenever
  passenger is used" (inecas@redhat.com)

* Mon Sep 23 2013 Ivan Necas <inecas@redhat.com> 0.0.9-1
- Sanitize Katello output (inecas@redhat.com)

* Wed Sep 18 2013 Ivan Necas <inecas@redhat.com> 0.0.8-1
- Paremetrize dns zone name (inecas@redhat.com)

* Tue Sep 17 2013 Ivan Necas <inecas@redhat.com> 0.0.7-1
- Make sure the CA is deployed to foreman before registering the smart proxy
  (inecas@redhat.com)

* Tue Sep 17 2013 Ivan Necas <inecas@redhat.com> 0.0.6-1
- Whitespace (inecas@redhat.com)
- No services installed by default (inecas@redhat.com)
- Certs for foreman, smart-proxy and puppetmaster (inecas@redhat.com)
- Ability to install foreman-proxy specific tools on master (inecas@redhat.com)
- Don't register in foreman unless specified explicitly (inecas@redhat.com)
- Use yum to install the package when not available locally (inecas@redhat.com)
- Basic katello_repo and katello_activation_key provider (inecas@redhat.com)
- Always generate all the certs that could be used by the node
  (inecas@redhat.com)

* Fri Sep 13 2013 Ivan Necas <inecas@redhat.com> 0.0.5-1
- Support for installing puppet server and CA (inecas@redhat.com)
* Thu Sep 12 2013 Ivan Necas <inecas@redhat.com> 0.0.4-1
- Don't save answers for node-certs-generate (inecas@redhat.com)
- Make sure oauth secret is set when registering foreman proxy
  (inecas@redhat.com)
- Make sure the system is registered to katello only when installing pulp node
  (inecas@redhat.com)
- first cut on foreman-proxy installation (inecas@redhat.com)
- Get submodules from foreman-installer (inecas@redhat.com)

* Mon Sep 09 2013 Ivan Necas <inecas@redhat.com> 0.0.3-1
- Fix generating certs on master (inecas@redhat.com)

* Mon Sep 09 2013 Ivan Necas <inecas@redhat.com> 0.0.2-1
- Random password for the pulp admin (inecas@redhat.com)
- Validate params (inecas@redhat.com)
- Set up releasers (inecas@redhat.com)
- Set the zero exit code if everything's fine (inecas@redhat.com)

* Wed Sep 04 2013 Ivan Necas <inecas@redhat.com> 0.0.1-1
- new package built with tito

