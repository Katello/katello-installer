JAVA_VERSION = %q(An OpenJDK version of Java greater than 1.7 should be installed.  For more details on the version currently installed, run 'java -version')

OPENJDK = %q(A version of java which is not OpenJDK is installed.

Please install an OpenJDK version greater than 1.7.  For more details on the version currently installed, run 'java -version')
 
def module_enabled?(name)
  mod = @kafo.module(name)
  return false if mod.nil?
  mod.enabled?
end

def error_exit(message, code)
  $stderr.puts message
  kafo.class.exit code
end

if module_enabled?('katello')
  java_version_string = `/usr/bin/java -version 2>&1`
  java_version = java_version_string.split("\n")[0].split('"')[1]

  # Check that OpenJDK 1.7 or higher is installed if any java is installed
  if java_version
    error_exit(JAVA_VERSION, 1) if java_version < "1.7"
    error_exit(OPENJDK, 2) unless java_version_string.include? "OpenJDK"
  end
end

