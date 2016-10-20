#### 2015-11-16 - 1.0.0
* Add FreeBSD support (#11, @misullivan).
* Add version parameter to set squid package version (#12, @actionjack).
* Add use_deprecated_opts parameter (#13, @actionjack).
* Add https_port parameter (@actionjack).
* Fix Ubuntu upstart error (#14, @actionjack).
* Fix coredump_dir not using variable in short template (#18, @wunzeco).
* Add puppetlabs-stdlib requirement, as empty() is used (#21, @cliffano).
* Fix operatingsystem comparison for RHEL < 6 (#27, @pecastro).
* Add ssl_ports and safe_ports array parameters (#30, @tinnightcap).
* Add validate_cmd for the configuration file (#31, @tinnightcap).
* Sort $config_hash to avoid order change in the configuration file.

#### 2014-07-15 - 0.2.3
* Add refresh_patterns config option (#7, @adamgraves85).

#### 2014-05-12 - 0.2.2
* Include short template and allow using custom templates (#5, @flypenguin).

#### 2014-03-28 - 0.2.1
* Fix coredump_dir on Debian/Ubuntu (#6, @jinnko).

#### 2013-09-09 - 0.2.0
* Add params, start supporting Debian OS family.
* Automatically pick the right package name on RHEL5.
* Added maximum_object_size{,_in_memory} parameters (Tristan Helmich).

#### 2013-05-24 - 0.1.1
* Add ChangeLog and update Modulefile.
* Add LICENSE file.
* Update README and use markdown.

