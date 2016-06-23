module Puppet::Parser::Functions
  # returns content of password file or creates random one (if not exists)
  newfunction(:find_or_create_password, :type => :rvalue) do |args|
    filename = args[0]

    if File.exists? filename
      puts "Loading random seed from #{filename}"
      IO.read(filename).chomp
    else
      puts "Generating new random seed in #{filename}"
      randomhash = function_generate_password([])
      File.open(filename, 'w', 0600) {|f| f.write(randomhash) }
      randomhash.chomp
    end
  end
end
