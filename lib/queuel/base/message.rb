module Queuel
  module Base
    class Message
      def self.new_from_bare(message_object)
        allocate.tap { |instance|
          instance.send :initialize_from_bare, message_object
        }
      end

      def delete
        raise NotImplementedError, "must define method #delete"
      end

      def initialize(id, body, queue = nil)
        self.id = id
        self.body = body
        self.queue = queue
      end

      attr_reader :id
      attr_reader :body
      attr_reader :queue

      private

      def initialize_from_bare(message_object)
        self.message_object = message_object
      end

      attr_accessor :message_object
      attr_writer :id
      attr_writer :body
      attr_writer :queue
    end
  end
end
