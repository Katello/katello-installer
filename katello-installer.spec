# Not building for scl rigth now
%undefine scl_prefix
%global scl_ruby /usr/bin/ruby

Name: katello-installer
Version: 2.1.0
Release: 1%{?dist}
Summary: Puppet-based installer for the Katello and Katello Capsule
Group: Applications/System
License: GPLv3+ and ASL 2.0
URL: http://katello.org
Source0: %{name}-%{version}.tar.gz

BuildArch: noarch

Requires: %{?scl_prefix}rubygem-kafo
Requires: %{?scl_prefix}rubygem-apipie-bindings >= 0.0.6
Requires: foreman-selinux

%description
A set of tools for installation of Katello and Katello Capsule,
including Foreman and Foreman Proxy.

%prep
%setup -q

%build
#replace shebangs
sed -ri '1sX(/usr/bin/ruby|/usr/bin/env ruby)X%{scl_ruby}X' bin/*

#configure the paths
sed -ri 'sX\./configX%{_sysconfdir}/%{name}Xg' bin/* config/*
sed -ri 'sX\:installer_dir.*$X:installer_dir: %{_datadir}/%{name}Xg' config/*
sed -ri 'sX\:modules_dir.*$X:modules_dir: %{_datadir}/%{name}/modulesXg' config/*
sed -ri 'sX\:hooks_dir.*$X:hooks_dir: %{_datadir}/%{name}/hooksXg' config/*

%install
install -d -m0755 %{buildroot}%{_sysconfdir}/%{name}
install -d -m0755 %{buildroot}%{_localstatedir}/log/%{name}
install -d -m0755 %{buildroot}/%{_datadir}/%{name}
install -d -m0755 %{buildroot}/%{_sbindir}
cp -dpR bin modules hooks checks %{buildroot}/%{_datadir}/%{name}
cp -dpR config/* %{buildroot}/%{_sysconfdir}/%{name}
ln -sf %{_datadir}/%{name}/bin/katello-installer %{buildroot}/%{_sbindir}/katello-installer
ln -sf %{_datadir}/%{name}/bin/katello-devel-installer %{buildroot}/%{_sbindir}/katello-devel-installer
ln -sf %{_datadir}/%{name}/bin/capsule-installer %{buildroot}/%{_sbindir}/capsule-installer
ln -sf %{_datadir}/%{name}/bin/capsule-certs-generate %{buildroot}/%{_sbindir}/capsule-certs-generate

%files
%defattr(-,root,root,-)
%doc README.*
%{_datadir}/%{name}
%dir %{_sysconfdir}/%{name}
%dir %{_localstatedir}/log/%{name}
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.katello-installer.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.katello-devel-installer.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.capsule-certs-generate.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/answers.capsule-installer.yaml
%config %{_sysconfdir}/%{name}/config_header.txt
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/katello-installer.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/katello-devel-installer.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/capsule-certs-generate.yaml
%config(noreplace) %attr(600, root, root) %{_sysconfdir}/%{name}/capsule-installer.yaml
%{_sbindir}/katello-installer
%{_sbindir}/katello-devel-installer
%{_sbindir}/capsule-installer
%{_sbindir}/capsule-certs-generate

%changelog
* Fri Sep 12 2014 Justin Sherrill <jsherril@redhat.com> 2.1.0-1
- bumping version to 2.1 (jsherril@redhat.com)

* Fri Sep 12 2014 Justin Sherrill <jsherril@redhat.com> 2.0.0-1
- bumping version to 2.0 (jsherril@redhat.com)
- fixes #7386 - fixing install with capsule-tftp=true (jsherril@redhat.com)
- fixes #7296, BZ1135127 - update pulp module (bbuckingham@redhat.com)
- refs #7104 - update service_wait module (bbuckingham@redhat.com)
- Fixes #7104,7239 - update certs and service_wait modules (inecas@redhat.com)
- Fixes #7159: Add missing foreman proxy options to capsule.
  (ericdhelms@gmail.com)
- refs #7264 - update puppet-elasticsearch module (bbuckingham@redhat.com)
- refs #7264 - check for java, unless installing for capsule & update
  elasticsearch (bbuckingham@redhat.com)
- Fixes #5219: Add option to clear Pulp data. (ericdhelms@gmail.com)

* Wed Aug 27 2014 Justin Sherrill <jsherril@redhat.com> 0.0.20-1
- Merge pull request #109 from jlsherrill/releng (jlsherrill@gmail.com)
- Merge pull request #108 from jlsherrill/7219 (jlsherrill@gmail.com)
- refs #5271 - update tito for el7 (jsherril@redhat.com)
- fixes #7219 - use /rhsm for bootstrap rpm on dev install
  (jsherril@redhat.com)
- fixes #7210 - make sure the Package['pulp-server'] is defined
  (jsherril@redhat.com)
- Merge pull request #83 from ehelms/fixes-5218 (ericdhelms@gmail.com)
- Refs #6297 - update puppet-katello module (inecas@redhat.com)
- Refs #6297 - use foreman-tasks instead of katello-jobs (inecas@redhat.com)
- Merge pull request #105 from jlsherrill/7145 (jlsherrill@gmail.com)
- fixes #7150 - stop elasticsearch before resetting data (jsherril@redhat.com)
- fixes #7145 - do not try to use ipv6 for service-wait network checks
  (jsherril@redhat.com)
- Refs #6875,#7115 - Update pulp,certs and capsule module (inecas@redhat.com)
- Fixes #6875 - Ability to pass own server certs for apache and smart-proxy
  (inecas@redhat.com)
- fixes #7108 - if using pulp at all, override both pulp and pulpnode settings
  (jsherril@redhat.com)
- Fixes #7077, #7006: update puppet-pulp module. (walden@redhat.com)
- fixes #7029,7007 - updating pulp-certs module (jsherril@redhat.com)
- Merge pull request #95 from jlsherrill/pulp_plugin (jlsherrill@gmail.com)
- refs #6330 - adding default option for pulp_master (jsherril@redhat.com)
- Merge pull request #99 from jmontleon/foreman-selinux-hard-dependency
  (jmontleo@redhat.com)
- Merge pull request #96 from iNecas/issue/6927 (inecas@redhat.com)
- Fixes #6927 - move checks on pulp capsule preconditions to pre_validate hook
  (inecas@redhat.com)
- Added foreman-selinux as hard dependency (jmontleo@redhat.com)
- Merge pull request #92 from bkearney/bkearney/6823 (bryan.kearney@gmail.com)
- Refs #5029 - specify inital org and location (jsherril@redhat.com)
- Fixes #6823 : Use kilobytes instead of human readable strings and be more
  permissive if mongo already exists (bkearney@redhat.com)
- refs #6698, #6491 update katello common and capsule modules
  (stbenjam@redhat.com)
- Merge pull request #91 from ehelms/fixes-6699 (ericdhelms@gmail.com)
- Fixes #6699: Fix broken devel installs and include missing HTTP configs.
  (ericdhelms@gmail.com)
- Merge pull request #86 from bkearney/bkearney/6675 (ericdhelms@gmail.com)
- Merge pull request #84 from ehelms/fixes-6530 (ericdhelms@gmail.com)
- Fixes #6530: Update proxy configurations for Pulp. (ericdhelms@gmail.com)
- Refs #6445 - Foreman update (mhulan@redhat.com)
- Fixes #6675: Verify that the hostname is all lowercase before starting the
  installation. (bkearney@redhat.com)
- Refs #6126: Updates to include setting RHSM url to /rhsm
  (ericdhelms@gmail.com)
- Merge pull request #80 from ehelms/fixes-6458 (ericdhelms@gmail.com)
- Fixes #6278 : Add additional checks to the installer. (bkearney@redhat.com)
- Fixes #5218: Add option to clear Puppet environments from disk.
  (ericdhelms@gmail.com)
- Refs #6418 - Fix keytool use for Java 6 compatibility. (awood@redhat.com)
- Fixes 5599: Set certs expiration to 20 years. (ericdhelms@gmail.com)
- Fixes #6458: Update Foreman modules to allow setting user parameters.
  (ericdhelms@gmail.com)
- Refs #6148: Add Candlepin/Qpid integration. (awood@redhat.com)
- Fixes #4650,#6359 - sets consumer rpm katello.yml (dtsang@redhat.com)
- Refs #6360 - Updated pulp module to include selinux fix (lzap+git@redhat.com)
- Update puppet modules (jsherril@redhat.com)
- Switch to puppetforge xinetd module (jsherril@redhat.com)
- Fixes #5639: Adds proxy configuration options for Katello and Pulp.
  (ericdhelms@gmail.com)
- Fixes BZ 1103224 - increase the timeout on passenger start
  (inecas@redhat.com)
- Merge pull request #70 from iNecas/master (inecas@redhat.com)
- Fixes #6143 and #5823 - support RHEL 7 and correct rhsm.conf config value
  (jmontleo@redhat.com)
- Fixes #6077, #6088 - update puppet-capsule module (inecas@redhat.com)
- Fixes #5012: Point at upstream postgresql module to prevent Candlepin DB
  error, BZ1072708. (ericdhelms@gmail.com)
- Fixes #5992 and #5993 - update katello_devel and pulp modules
  (jmontleo@redhat.com)
- Update puppet modules (jsherril@redhat.com)
- Merge pull request #64 from iNecas/apipie-bindings-deps (inecas@redhat.com)
- Refs #4244: Prevent seg fault on Ruby 1.8.7. (ericdhelms@gmail.com)
- Refs #5815 - install dependencies for successful proxy registration
  (inecas@redhat.com)
- Update puppet modules (jsherril@redhat.com)
- Update puppet modules (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Merge pull request #60 from ehelms/fixes-5751 (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Fixes #5678: Specifying consistent log directory for installer logs.
  (ericdhelms@gmail.com)
- Fixes #5704: Removing unused foreman_api gem requirement.
  (ericdhelms@gmail.com)
- Fixes #5641: Setting EPEL and SCL enablement to false by default.
  (ericdhelms@gmail.com)
- Update puppet modules (inecas@redhat.com)
- Remove rvm from Puppetfile (inecas@redhat.com)
- Refs #5423 - update package description (inecas@redhat.com)
- Refs #5423 - make the example working directly (inecas@redhat.com)
- Refs #5423 - inform about where capsule-installer is coming from
  (inecas@redhat.com)
- Refs #5423 - unify the config files naming (inecas@redhat.com)
- Fixes #5423 - capsule-certs-generate and capsule-installer scripts
  (inecas@redhat.com)
- Fixes #5579: Adding checks/ directory to the RPM spec. (ericdhelms@gmail.com)
- Fixes #5576 - make sure the params file for discovery plugin is loaded
  (inecas@redhat.com)
- Removing RVM module. (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Fixes #5476: Adding documentation to specify how to handle installer issues.
  (ericdhelms@gmail.com)
- Merge pull request #45 from jlsherrill/plugin (jlsherrill@gmail.com)
- Merge pull request #44 from dgoodwin/update-modules (ericdhelms@gmail.com)
- references #4991 - adding foreman plugins to default install
  (jsherril@redhat.com)
- Merge pull request #41 from ehelms/fixes-5131 (ericdhelms@gmail.com)
- Merge pull request #37 from ehelms/fixes-4770 (ericdhelms@gmail.com)
- Update puppet modules (dgoodwin@redhat.com)
- Minor touchups to README for updating modules. (dgoodwin@redhat.com)
- Fixes #5131: Adds hooks to display UI url and capsule information post
  install. (ericdhelms@gmail.com)
- Fixes #4770: Adding reset option to installer script. (ericdhelms@gmail.com)
- Merge pull request #39 from mccun934/20140402-1013 (mmccune@gmail.com)
- addresses #5020 by merging upstream puppet module changes
  (mmccune@redhat.com)
- fixes #5035 by adding gem info to the README (mmccune@redhat.com)
- Update puppet modules (ericdhelms@gmail.com)
- Fixes #4909: Enabling locations by default. (ericdhelms@gmail.com)
- Copy in cecks dir from f-i (gsutclif@redhat.com)
- Update puppet modules (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Adds a katello-devel-installer command to run an install of a Katello
  development setup. (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Apache cert name updates. (ericdhelms@gmail.com)
- Update puppet modules (ericdhelms@gmail.com)
- Update puppet modules (inecas@redhat.com)
- Remove temporary workaround for apache module (inecas@redhat.com)
- Merge pull request #28 from ehelms/remove-rpms (ericdhelms@gmail.com)
- Update puppet modules (jsherril@redhat.com)
- locking down mysql and firewall deps (jsherril@redhat.com)
- Removing errant RPMs from source. (ericdhelms@gmail.com)
- Update to librarian (inecas@redhat.com)
- Update README (inecas@redhat.com)
- Merge commit '0695216e35d54ea03c415c4c77b3a8bff209c104' into capsule
  (inecas@redhat.com)
- Squashed 'modules/katello/' changes from 18f4d5d..02b8cbe (inecas@redhat.com)
- Merge commit '03f7ef40106b4d2b5da36eb97ecf13caf99b7f79' into capsule
  (inecas@redhat.com)
- Squashed 'modules/pulp/' changes from b5eac8f..9366559 (inecas@redhat.com)
- Squashed 'modules/katello/' changes from 8e5af7b..18f4d5d (inecas@redhat.com)
- Merge commit '02e68fc88d56bab8240d2d41e3d74efc1ef2f5b5' into capsule
  (inecas@redhat.com)
- Merge commit 'bfebfd738bbcc0e869abe91f64d414265fe83951' into capsule
  (inecas@redhat.com)
- Squashed 'modules/certs/' changes from 7e897f5..75bb0e6 (inecas@redhat.com)
- Merge commit 'd03bcb25393f8c72026d23de96ca3e2740b66856' as 'modules/capsule'
  (inecas@redhat.com)
- Squashed 'modules/capsule/' content from commit 131a8fd (inecas@redhat.com)
- Merge commit 'ebd2dd0ea5add08b87abe7043130be42e15c50f9' into capsule
  (inecas@redhat.com)
- Squashed 'modules/candlepin/' changes from 26380df..6a80309
  (inecas@redhat.com)
- improve scratch building (inecas@redhat.com)
- Enforce params prefixing (inecas@redhat.com)
- Initial support of capsule settings (inecas@redhat.com)
- Setting certs group to 'foreman' in the answers file. (ericdhelms@gmail.com)
- Merge commit '9108da73f0e516ba971108e85bdb60bd3ac51dea'
  (ericdhelms@gmail.com)
- Squashed 'modules/qpid/' changes from f450601..b39fa9d (ericdhelms@gmail.com)
- Squashed 'modules/pulp/' changes from faa7ef8..b5eac8f (ericdhelms@gmail.com)
- Merge commit '420337d0f21c0edb9ea3804cee8a3c69ea329c4c'
  (ericdhelms@gmail.com)
- Squashed 'modules/katello/' changes from 2a9487c..8e5af7b
  (ericdhelms@gmail.com)
- Merge commit '5b815112fdb762c4f9f71429f9dc693955e93425'
  (ericdhelms@gmail.com)
- Squashed 'modules/certs/' changes from c5901b0..7e897f5
  (ericdhelms@gmail.com)
- Merge commit '289d1d49bd2992d833ae9031760ca4ef3a8afbd3'
  (ericdhelms@gmail.com)
- Squashed 'modules/candlepin/' changes from 2db3623..26380df
  (ericdhelms@gmail.com)
- Merge commit 'fcd38a8c240b5a4258b05cd41d44d4abe6329397'
  (ericdhelms@gmail.com)
- Removing errant reference to puppet-kafo that got renamed to
  katello_installer. (ericdhelms@gmail.com)
- Merge pull request #22 from jlsherrill/foreman_updates (jlsherrill@gmail.com)
- removing apache from katello submodule list (jsherril@redhat.com)
- Squashed 'modules/pulp/' changes from bd76690..faa7ef8 (jsherril@redhat.com)
- Squashed 'modules/katello/' changes from 3f76715..2a9487c
  (jsherril@redhat.com)
- Squashed 'modules/certs/' changes from 9514640..c5901b0 (jsherril@redhat.com)
- removing unused modules (jsherril@redhat.com)
- Merge commit '46043a2e66ba961063d2399f79549099e5f51e6c' (jsherril@redhat.com)
- Squashed 'modules/foreman/' changes from dce8ded..2436921
  (jsherril@redhat.com)
- Merge commit 'd2b3eed8cb9d72f15a5b5c7c3361f976d1bc7563' (jsherril@redhat.com)
- Squashed 'modules/foreman_proxy/' changes from abfdf11..b157cc1
  (jsherril@redhat.com)
- Merge commit '8b4a4bb571bb4d209e6309d77c91d669ca2f1258' (jsherril@redhat.com)
- Squashed 'modules/puppet/' changes from 7a03de3..488e069
  (jsherril@redhat.com)
- Merge commit '025cb0dc100ddea59c294b2b37117eba2b658437' (jsherril@redhat.com)
- Merge commit 'c7f64591f097fbc8b951ceb0eae4c9aeeecc722c' (jsherril@redhat.com)
- Squashed 'modules/tftp/' changes from 59b902d..19369d2 (jsherril@redhat.com)
- Squashed 'modules/dns/' changes from ef5e288..06f8dec (jsherril@redhat.com)
- Merge commit 'f03a89617e17b9ad95a7bb60a2b0a78a88a2eccc' (jsherril@redhat.com)
- Squashed 'modules/dhcp/' changes from 0dc6d29..3ecc8b2 (jsherril@redhat.com)
- Merge commit '0c571d25647f6d20c08a05835b16a3f7cd725678' (jsherril@redhat.com)
- Squashed 'modules/apache/' changes from 94c1b55..c9fef6c
  (jsherril@redhat.com)
- updating foreman installer module list (jsherril@redhat.com)
- Setting the node-install modules dir as a configuration variable such that
  the node-install command isn't relative to the install directory.
  (ericdhelms@gmail.com)
- Fixes issue with with Puppet 3+ calling custom functions. (ehelms@redhat.com)

* Wed Jan 22 2014 Eric D Helms <ehelms@redhat.com> 0.0.19-1
- new package built with tito

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

