require 'forwardable'
module Queuel
  module Base
    class Message
      extend Forwardable
      def_delegators :Queuel,
        :decode_by_default?,
        :decoder,
        :encode_by_default?,
        :encoder

      def initialize(message_object = nil)
        self.message_object = message_object
      end

      def delete
        raise NotImplementedError, "must define method #delete"
      end

      def empty?
        body.to_s.empty?
      end
      alias blank? empty?

      def present?
        !empty?
      end

      attr_reader :id
      attr_reader :body
      attr_reader :queue

      private
      attr_accessor :message_object
      attr_writer :id
      attr_writer :body
      attr_writer :queue
    end
  end
end
