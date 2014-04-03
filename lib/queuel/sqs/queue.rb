require 'queuel/base/queue'
require 'forwardable'
module Queuel
  module SQS
    class Queue < Base::Queue
      extend Forwardable

      def push(message, options = {})
        queue_connection.send_message build_push_message(message, options)
      end

      def approximate_number_of_messages
        queue_connection.approximate_number_of_messages
      end

      def size
        approximate_number_of_messages
      end

      private
      def pop_bare_message(options = {})
        queue_connection.receive_message options
      end


      def queue_connection
        @queue_connection ||= client.queues.named(name)
      end
    end
  end
end
