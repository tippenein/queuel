require "queuel/version"
require "forwardable"
require "queuel/configurator"
require "queuel/introspect"

require "queuel/base/engine"
require "queuel/base/queue"
require "queuel/base/message"
require "queuel/base/poller"

require "queuel/null/engine"
require "queuel/null/queue"
require "queuel/null/message"
require "queuel/null/poller"

require "queuel/iron_mq/engine"
require "queuel/iron_mq/queue"
require "queuel/iron_mq/message"
require "queuel/iron_mq/poller"

require "queuel/client"

module Queuel
  extend Introspect
  class << self
    extend Forwardable
    def_delegators :client, :push, :pop, :receive, :with
    def_delegators :config, :credentials, :default_queue, :receiver_threads
    alias << pop
  end

  def self.engine
    requires
    const_with_nesting engine_const_name
  end

  def self.configure(&block)
    config.instance_eval &block
  end

  def self.config
    @config ||= Configurator.new
  end

  def self.client
    Client.new engine, credentials
  end

  def self.engines
    {
      iron_mq: { require: 'iron_mq', const: "IronMq" },
      null: { const: "Null" }
    }
  end

  def self.requires
    require engines[config.engine][:require] if engines.fetch(config.engine, {})[:require]
  end

  def self.engine_const_name
    "Queuel::#{configured_engine_name}::Engine"
  end

  def self.logger
    config.logger.tap { |log|
      log.level = config.log_level
    }
  end

  def self.configured_engine_name
    engines.fetch(config.engine, {}).fetch(:const, nil) ||
      logger.warn("Using Null Engine, for compatability.") &&
      engines[:null][:const]
  end
end
