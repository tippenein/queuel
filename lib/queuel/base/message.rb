require 'forwardable'
module Queuel
  module Base
    class Message
      extend Forwardable
      private
      def_delegators :Queuel,
        :decode_by_default?,
        :decoder,
        :encode_by_default?,
        :encoder
      attr_accessor :message_object
      attr_writer :id
      attr_writer :queue

      public

      attr_reader :id
      attr_writer :body
      attr_accessor :raw_body
      attr_reader :queue

      def initialize(message_object = nil)
        self.message_object = message_object
      end

      def delete
        raise NotImplementedError, "must define method #delete"
      end

      def body
        @body || decoded_raw_body
      end

      def empty?
        raw_body.to_s.empty?
      end
      alias blank? empty?

      def present?
        !empty?
      end

      private

      def decoded_raw_body
        decode_body? ? decoder.call(raw_body) : raw_body
      end

      def encoded_body
        encode_body? ? encoder.call(body) : body
      end

      def encode_body?
        !@body.to_s.empty? && !encoder.nil? && encode_by_default?
      end

      def decode_body?
        !decoder.nil? && decode_by_default? && raw_body.is_a?(String)
      end
    end
  end
end
