module Queuel
  module Base
    class Engine
      def self.inherited(klass)
        klass.class_eval do
          def queue_klass
            self.class.const_with_nesting "Queue"
          end
        end
      end

      def self.module_names
        self.to_s.split("::")[0..-2].join("::")
      end

      def self.const_with_nesting(other_name)
        Object.module_eval("#{module_names}::#{other_name}", __FILE__, __LINE__)
      end

      def initialize(credentials = {})
        self.credentials = credentials
        self.memoized_queues = {}
      end

      def queue(which_queue)
        memoized_queues[which_queue.to_s] ||= queue_klass.new(client, which_queue)
      end

      private
      attr_accessor :credentials
      attr_accessor :memoized_queues

      def client
        @client ||= client_klass.new credentials
      end

      def client_klass
        raise NotImplementedError, "Must define a Queue class"
      end
    end
  end
end
