module Queuel
  class Configurator
    InvalidConfigurationError = Class.new StandardError
    private
    attr_accessor :option_values

    def self.option_values
      @option_values ||= {}
    end

    def self.define_param_accessors(param_name)
      define_method param_name do |*values|
        value = values.first
        value ? self.send("#{param_name}=", value) : retrieve(param_name)
      end
      define_method "#{param_name}=" do |value|
        instance_variable_set "@#{param_name}", value
        validate! param_name, value
      end
    end

    def validate(param_name, value)
      validator = self.class.option_values[param_name][:validator] || ->(val) { true }
      validator.call value
    end

    def validate!(param_name, value)
      validate(param_name, value) || raise(InvalidConfigurationError, "#{value} is not a valid value for #{param_name}")
    end

    def retrieve(param)
      if instance_variable_defined?("@#{param}")
        instance_variable_get("@#{param}")
      else
        self.class.option_values[param][:default]
      end
    end

    def self.param(param_name, options = {})
      attr_accessor param_name
      self.option_values[param_name] = options
      define_param_accessors param_name
      public param_name
      public "#{param_name}="
    end

    public

    param :credentials
    param :engine
    param :default_queue
    param :receiver_threads, default: 1
    param :logger, default: MonoLogger.new(STDOUT), validator: ->(logger) {
      %w[info warn debug level].all? { |msg| logger.respond_to? msg }
    }
    param :log_level, default: MonoLogger::WARN
  end
end
