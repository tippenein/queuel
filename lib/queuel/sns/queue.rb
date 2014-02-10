require 'queuel/base/queue'
require 'forwardable'
module Queuel
  module SNS
    class Queue < Base::Queue
      extend Forwardable

      def push(message, options = {})
        queue_connection.publish build_push_message(message, options)
      end

      private

      def queue_connection
        @queue_connection ||= client.topics[name]
      end
    end
  end
end
