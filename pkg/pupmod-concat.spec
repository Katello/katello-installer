#
# Copyright (C) 2012 Onyx Point, Inc. <http://onyxpoint.com/>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
Summary: Concat Puppet Module
Name: pupmod-concat
Version: 2.0
Release: 0
License: Apache 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: puppet-server >= 2.6
Buildarch: noarch

%description
This puppet module provides the concat_build and concat_fragment custom types.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

# Make your directories here.
mkdir -p %{buildroot}/etc/puppet/modules/concat/lib

# Now install the files.
cp -r lib %{buildroot}/etc/puppet/modules/concat
chmod -R u=rwX,g=rX,o-rwx %{buildroot}/etc/puppet/modules/concat

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

%files
%defattr(-,root,puppet)
/etc/puppet/modules/concat

%changelog
* Tue Aug 14 2012 Morgan Haskel <morgan.haskel@onyxpoint.com> - 2.0-1
- Fixed bug in auto-creation of build objects.
* Sun Jul 22 2012 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.0-0
 - Multiple updates to the concat codebase.
    
   - append_newline parameter added to concat_build.
   - Default file delimiter is now and empty file delimiter which is affected by
     append_newline.
   - Sort and uniq work on all lines, not whole file fragments.
   - Normal concats work on whole file fragments so be sure to match up your
     delimiters and newline settings in sub-builds if that's what you want.
   - insync? etc... now works properly for both fragments and build objects.
   - Fragments auto-create an associated build object if one does not exist.
   - Build now separates the overwriting of a target from the creation of the
     output file.
   - Documentation updated to describe multi-level builds.
   - Code updated for compatiblity with Ruby 1.9.
   - All instances of a hard coded 'vardir' have been replaced with calls to
     Puppet[:vardir]

* Sun Jun 26 2011 Trevor Vaughan <tvaughan@onyxpoint.com> - 1.0-1
- Modified to use the Apache 2.0 license instead of the GPLv3

* Mon Feb 07 2011 Morgan Haskel <mhaskel@onyxpoint.com> - 1.0-0
- Initial implementation of concat_build and concat_fragment custom types.
