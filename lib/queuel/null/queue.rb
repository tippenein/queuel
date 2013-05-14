require 'queuel/null/poller'
module Queuel
  module Null
    class Queue
      def initialize(*)
      end

      # For IronMQ it should just be (message)
      def push(*)
      end

      def pop(*args, &block)
      end

      def receive(options = {}, &block)
        Poller.new(options, block).poll
      end
    end
  end
end
