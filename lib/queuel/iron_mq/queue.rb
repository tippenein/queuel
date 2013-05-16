require 'queuel/iron_mq/poller'
module Queuel
  module IronMq
    class Queue < Base::Queue
      # For IronMQ it should just be (message)
      def push(message)
        queue_connection.post message
      end

      def peek(options = {})
        queue_connection.peek options
      end

      private
      def pop_bare_message(options = {})
        queue_connection.get options
      end

      def queue_connection
        @queue_connection ||= client.queue(name)
      end
    end
  end
end
