#  Copyright 2015 Puppet Community
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

require 'puppetlabs_spec_helper/module_spec_helper'

# From https://gist.github.com/stefanozanella/4190920
# Make stdlib (i.e. its functions) available to rspec so our own functions that
# require stdlib functions can load them.
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'fixtures', 'modules', 'stdlib', 'lib')

RSpec.configure do |configuration|
  configuration.mock_with :rspec do |c|
    c.syntax = :expect
  end
end
