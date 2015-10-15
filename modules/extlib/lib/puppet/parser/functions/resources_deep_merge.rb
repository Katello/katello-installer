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

Puppet::Parser::Functions.newfunction(:resources_deep_merge, :type => :rvalue, :doc => <<-EOS
Deeply merge a "defaults" hash into a "resources" hash like the ones expected
by create_resources(). Internally calls the puppetlabs-stdlib function
deep_merge(). In case of duplicate keys the "resources" hash keys win over the
"defaults" hash keys.

Example:

$defaults_hash = {
  'one'   => '1',
  'two'   => '2',
  'three' => '3',
  'four'  => {
    'five'  => '5',
    'six'   => '6',
    'seven' => '7',
  }
}

$numbers_hash = {
  'german' => {
    'one'   => 'eins'
    'three' => 'drei',
    'four'  => {
      'six' => 'sechs',
    }
  },
  'french' => {
    'one' => 'un',
    'two' => 'deux',
    'four' => {
      'five'  => 'cinq',
      'seven' => 'sept',
    }
  }
}

$result_hash = resources_deep_merge($numbers_hash, $defaults_hash)

The $result_hash then looks like this:

# $result_hash = {
#   'german' => {
#     'one'   => 'eins',
#     'two'   => '2',
#     'three' => 'drei',
#     'four'  => {
#       'five'  => '5',
#       'six'   => 'sechs',
#       'seven' => '7',
#     }
#   },
#   'french' => {
#     'one'   => 'un',
#     'two'   => 'deux',
#     'three' => '3',
#     'four'  => {
#       'five'  => 'cinq',
#       'six'   => '6',
#       'seven' => 'sept',
#     }
#   }
# }

EOS
                                     ) do |args|
  Puppet::Parser::Functions.function('deep_merge')

  fail ArgumentError, ("resources_deep_merge(): wrong number of arguments (#{args.length} for 2)") if args.length != 2
  resources, defaults = args
  fail ArgumentError, ('resources_deep_merge(): first argument must be a hash')  unless resources.is_a?(Hash)
  fail ArgumentError, ('resources_deep_merge(): second argument must be a hash') unless defaults.is_a?(Hash)

  deep_merged_resources = {}
  resources.each do |title, params|
    deep_merged_resources[title] = function_deep_merge([defaults, params])
  end

  return deep_merged_resources
end
