module Queuel
  module SQS
    class Message < Base::Message
      def raw_body
        @raw_body ||
          (message_object && raw_body_with_sns_check) ||
          encoded_body
      end

      def delete
        message_object.delete
      end

      [:id, :queue].each do |delegate|
        define_method(delegate) do
          instance_variable_get("@#{delegate}") || message_object && message_object.public_send(delegate)
        end
      end

      def raw_body_with_sns_check
        begin
          message_object.as_sns_message.body
        rescue ::JSON::ParserError
          message_object.body
        end
      end
      private :raw_body_with_sns_check
    end
  end
end
