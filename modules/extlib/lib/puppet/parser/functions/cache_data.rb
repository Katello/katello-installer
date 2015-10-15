require 'fileutils'
require 'yaml'
require 'etc'

# Retrieves data from a cache file, or creates it with supplied data if the file doesn't exist
#
# Useful for having data that's randomly generated once on the master side (e.g. a password), but
# then stays the same on subsequent runs.
#
# Usage: cache_data(namespace, name, initial_data)
# Example: $password = cache_data('mysql', 'mysql_password', 'this_is_my_password')
Puppet::Parser::Functions.newfunction(:cache_data, :type => :rvalue) do |args|
  fail Puppet::ParseError, 'Usage: cache_data(namespace, name, initial_data)' unless args.size == 3

  namespace = args[0]
  fail Puppet::ParseError, 'Must provide namespace' if namespace.empty?

  name = args[1]
  fail Puppet::ParseError, 'Must provide data name' if name.empty?

  initial_data = args[2]

  cache_dir = File.join(Puppet[:vardir], namespace)
  cache = File.join(cache_dir, name)

  if File.exist? cache
    YAML.load(File.read(cache))
  else
    FileUtils.mkdir_p(cache_dir)
    File.open(cache, 'w', 0600) do |c|
      c.write(YAML.dump(initial_data))
    end
    File.chown(File.stat(Puppet[:vardir]).uid, nil, cache)
    File.chown(File.stat(Puppet[:vardir]).uid, nil, cache_dir)
    initial_data
  end
end
