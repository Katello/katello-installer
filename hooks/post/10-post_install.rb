# helpers
def module_enabled?(name)
  mod = @kafo.module(name)
  return false if mod.nil?
  mod.enabled?
end

def proxy_available?
  module_enabled?('capsule') &&
   (@kafo.param('capsule', 'puppet').value ||
    @kafo.param('capsule', 'puppetca').value ||
    @kafo.param('capsule', 'dhcp').value ||
    @kafo.param('capsule', 'dns').value ||
    @kafo.param('capsule', 'tftp').value)
end

if [0,2].include? @kafo.exit_code
  say "  <%= color('Success!', :good) %>"

  # Fortello UI?
  if module_enabled?('katello')
    say "  * <%= color('Katello', :info) %> is running at <%= color('#{@kafo.param('foreman','foreman_url').value}', :info) %>"
    say "      Default credentials are '<%= color('admin:changeme', :info) %>'" if @kafo.param('foreman','authentication').value
  end

  # Capsule?
  if proxy_available?
    say "  * <%= color('Capsule', :info) %> is running at <%= color('https://#{Facter.value(:fqdn)}:#{@kafo.param('capsule', 'foreman_proxy_port').value}', :info) %>"
  end

  exit_code = 0
else
  say "  <%= color('Something went wrong!', :bad) %> Check the log for ERROR-level output"
  exit_code = @kafo.exit_code
end

# This is always useful, success or fail
log = @kafo.config.app[:log_dir] + '/' + @kafo.config.app[:log_name]
say "  The full log is at <%= color('#{log}', :info) %>"
