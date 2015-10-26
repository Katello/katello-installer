#!/usr/bin/env ruby

`git clone https://github.com/puppetlabs/puppetlabs-stdlib stdlib`

extlib_functions = []
Dir.glob('lib/puppet/parser/functions/*.rb').each do |path|
  extlib_functions << path.split('/')[-1].split('.')[0]
end

stdlib_functions = []
Dir.glob('stdlib/lib/puppet/parser/functions/*.rb').each do |path|
  stdlib_functions << path.split('/')[-1].split('.')[0]
end

puts 'Stdlib functions:'
puts stdlib_functions
puts ''

puts 'Extlib functions:'
puts extlib_functions
puts ''

duplicate_functions = stdlib_functions & extlib_functions
puts 'Duplicate functions:'
puts duplicate_functions
puts ''

if duplicate_functions.length > 0
  puts 'Duplicate function(s) found! Please have unique function names between'
  puts 'stdlib and extlib'
  puts 'Test failed'
  exit 1
else
  puts 'No duplicate functions found'
  puts 'Test passed'
  exit 0
end
