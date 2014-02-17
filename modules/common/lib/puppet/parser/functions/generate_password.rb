module Puppet::Parser::Functions
  newfunction(:generate_password, :type => :rvalue) do |args|
    # Ruby 1.8 does not have SecureRandom but openssl is installed
    randomhash = `openssl rand -base64 24`
    randomhash.chomp
  end
end
