require "queuel/version"
require "forwardable"
require "queuel/null/engine"
require "queuel/iron_mq/engine"
require "queuel/iron_mq/queue"
require "queuel/client"

module Queuel
  class << self
    extend Forwardable
    def_delegators :client, :push, :pop, :receive
    def_delegators :config, :credentials, :default_queue
    alias << pop
  end

  def self.engine
    config.engine || Null::Engine
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

  class Configurator
    def self.param(*params)
      params.each do |name|
        attr_accessor name
        define_method name do |*values|
          value = values.first
          value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
        end
      end
    end

    param :credentials
    param :engine
    param :default_queue
  end
end
