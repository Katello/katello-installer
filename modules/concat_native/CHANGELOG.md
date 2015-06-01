# Changelog

## 1.5.0
No functional changes.

This module is now deprecated in favour of [puppetlabs-concat](https://forge.puppetlabs.com/puppetlabs/concat) 2.0.0 or higher.

It used to be a better alternative than the 1.x series by being implemented as
a native type instead of shell scripts, but 2.x rewrote concat as native types.
theforeman modules will be updated to use puppetlabs-concat and this module
will not be maintained.

## 1.4.0
* Change state directory to 'concat_native' from 'concat' to avoid conflict

## 1.3.2
* Fix project URL and update metadata

## 1.3.1
* use client's vardir from stdlib fact if available
