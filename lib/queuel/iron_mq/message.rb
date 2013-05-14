require 'forwardable'
module Queuel
  module IronMq
    class Message
      extend Forwardable
      def_delegators :message_object, :delete

      def self.new_from_bare(message_object)
        allocate.tap { |instance|
          instance.send :initialize_from_iron_mq_object, message_object
        }
      end

      def initialize_from_iron_mq_object(message_object)
        self.message_object = message_object
      end
      private :initialize_from_iron_mq_object

      def initialize(id, body, queue = nil)
        self.id = id
        self.body = body
        self.queue = queue
      end

      def body
        @body || message_object && message_object.msg
      end

      [:id, :queue].each do |delegate|
        define_method(delegate) do
          instance_variable_get("@#{delegate}") || message_object && message_object.public_send(delegate)
        end

        private
        attr_writer delegate
      end

      private
      attr_accessor :message_object
      attr_writer :body
    end
  end
end
