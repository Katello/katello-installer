#!/usr/bin/env ruby

SIZE = %q(The installation requires at least 5G of storage.) 

def error_exit(message, code)
  $stderr.puts message
  exit code
end

begin
    total_space = `df -H --total`.split("\n")[-1].split()[3]

    # Look for a value greater than 4GB
    error_exit(SIZE, 1) unless total_space.include?("G")
    error_exit(SIZE, 2) if total_space.gsub("G","").to_i < 5
rescue
    # Eat the exception and continue
end
