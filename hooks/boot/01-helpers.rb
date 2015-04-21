class Kafo::Helpers
  class << self
    def module_enabled?(kafo, name)
      mod = kafo.module(name)
      return false if mod.nil?
      mod.enabled?
    end

    def log_and_say(level, message)
      style = level == :error ? 'bad' : level
      say "<%= color('#{message}', :#{style}) %>"
      Kafo::KafoConfigure.logger.send(level, message)
    end

    def read_cache_data(param)
      YAML.load_file("/var/lib/puppet/foreman_cache_data/#{param}")
    end

    def execute(commands)
      commands = commands.is_a?(Array) ? commands : [commands]
      results = []

      commands.each do |command|
        output = `#{command} 2>&1`

        if $?.success?
          ::Kafo::KafoConfigure.logger.debug output.to_s
          results << true
        else
         ::Kafo::KafoConfigure.logger.error output.to_s
          results << false
        end
      end

      !results.include? false
    end
  end
end
