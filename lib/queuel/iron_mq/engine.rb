module Queuel
  module IronMq
    class Engine
      IronMqMissingError = Class.new(StandardError)

      def initialize(credentials = {})
        self.credentials = credentials
        self.memoized_queues = {}
      end

      def queue(which_queue)
        memoized_queues[which_queue.to_s] ||= Queue.new(client, which_queue)
      end

      private
      attr_accessor :credentials
      attr_accessor :memoized_queues

      def client
        @client ||= client_proper.new credentials
      end

      def try_typhoeus
        require 'iron_mq'
      rescue LoadError
        false
      end

      def client_proper
        if defined?(::IronMQ::Client)
          try_typhoeus
          ::IronMQ::Client
        else
          begin
            require 'iron_mq'
            ::IronMQ::Client
          rescue LoadError
            raise(IronMqMissingError)
          end
        end
      end
    end
  end
end
