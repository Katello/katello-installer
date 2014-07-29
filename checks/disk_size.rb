#!/usr/bin/env ruby

DISK_SIZE = %q(The installation requires at least 5G of storage.)

def error_exit(message, code)
  $stderr.puts message
  exit code
end

begin
    # Error out if there is not 5 gigs of free space.
    # If mongo is installed, which is the big item, then add
    # the current mongo space to the total
    gb_limit = 5 * 1024 * 1024
    mongo_dir = "/var/lib/mongodb"
    total_space = `df -k --total --exclude-type=tmpfs`.split("\n")[-1].split()[3].to_i
    mongo_size = File.directory?(mongo_dir) ? `du -s  /var/lib/mongodb/`.split()[0].to_i : 0
    error_exit(DISK_SIZE, 1)  if (total_space + mongo_size) < gb_limit
rescue
    # Eat the exception and continue
end
