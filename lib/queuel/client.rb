module Queuel
  class Client
    extend Forwardable
    def_delegators :queue_connection, :push, :pop, :receive

    def initialize(engine, credentials, init_queue = nil)
      self.engine = engine
      self.credentials = credentials
      self.given_queue = init_queue
    end

    def with(change_queue = nil)
      self.clone.tap { |client| client.given_queue = change_queue }
    end

    def queue
      given_queue || Queuel.default_queue
    end

    protected
    attr_accessor :given_queue

    private

    def queue_connection
      engine_client.queue (given_queue || default_queue)
    end

    def engine_client
      @engine_client ||= engine.new credentials
    end

    attr_accessor :credentials
    attr_accessor :engine
  end
end
