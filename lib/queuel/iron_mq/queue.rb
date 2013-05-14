require 'queuel/iron_mq/poller'
module Queuel
  module IronMq
    class Queue
      def initialize(client, queue_name)
        self.client = client
        self.name = queue_name
      end

      # For IronMQ it should just be (message)
      def push(*args)
        queue_connection.post *args
      end

      def pop(*args, &block)
        bare_message = queue_connection.get(*args)
        unless bare_message.nil?
          Message.new_from_iron_mq_object(bare_message).tap { |message|
            if block_given? && !message.nil?
              yield message
              message.delete
            end
          }
        end
      end

      def receive(options = {}, &block)
        Poller.new(self, options, block).poll
      end

      private
      attr_accessor :client
      attr_accessor :name

      def queue_connection
        @queue_connection ||= client.queue(name)
      end
    end
  end
end
