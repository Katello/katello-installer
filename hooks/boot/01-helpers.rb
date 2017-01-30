class Kafo::Helpers
  class << self
    def puppet_dir
      @puppet_dir ||= File.directory?('/opt/puppetlabs/puppet') ? '/opt/puppetlabs/puppet/cache' : '/var/lib/puppet'
    end

    def module_enabled?(kafo, name)
      mod = kafo.module(name)
      return false if mod.nil?
      mod.enabled?
    end

    def log_and_say(level, message)
      style = case level
              when :error
                'bad'
              when :debug
                'yellow'
              else
                level
              end

      # \ and ' characters could cause trouble in ERB, make sure to escape them
      escaped_message = message.gsub('\\', '\\\\\\').gsub("'", %q{\\\'})
      say "<%= color('#{escaped_message}', :#{style}) %>"
      Kafo::KafoConfigure.logger.send(level, message)
    end

    def read_cache_data(param)
      YAML.load_file("#{puppet_dir}/foreman_cache_data/#{param}")
    end

    def execute(commands)
      commands = commands.is_a?(Array) ? commands : [commands]
      results = []
      commands.each do |command|
        results << execute_command(command)
      end
      !results.include? false
    end

    def execute_command(command)
      process = IO.popen("#{command} 2>&1") do |io|
        while line = io.gets
          line.chomp!
          log_and_say(:debug, line)
        end
        io.close
        if $?.success?
          log_and_say(:debug, "#{command} finished successfully!")
        else
          log_and_say(:error, "#{command} failed! Check the output for error!")
        end
        $?.success?
      end
    end
  end
end
