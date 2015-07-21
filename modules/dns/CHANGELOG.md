# Changelog

## 3.0.0
* Change theforeman-concat_native to puppetlabs-concat
* Test with Puppet 4

## 2.0.1
* Fix template variable lookups under the future parser

## 2.0.0
* Add masters/allow_transfer parameters to dns::zone to configure master/slave
  relationships
* Require that dns is explicitly included, not implicitly included by dns::zone
* Add and refactor dns::zone parameters
* Improve dns::zone defaults for soa, soaip etc.
* Replace dns::zone parameters for zone path and filename
* Remove unused rndc_alg/secret parameters
* Improve style and fix linting issues
* Refresh README

## 1.4.0
* Add listen_on_v6 parameter
* Prevent create-rndc key exec changing on every run
* Puppet 2.6 support deprecated
* Update gitignore, change fixtures to HTTPS
