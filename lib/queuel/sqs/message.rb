module Queuel
  module SQS
    class Message < Base::Message
      def raw_body

        if !message_object.nil? && message_object.body.bytesize > 40*1024
          key = SecureRandom.urlsafe_base64
          write_to_s3 message key
          raw_body[:message_ref] = AWS::S3::S3Object.url_for(
            "messages/#{key}",
            config.bucket_name)
          raw_body
        else
          @raw_body ||
            (message_object && raw_body_with_sns_check) ||
            encoded_body
        end
      end

      def write_to_s3 (message, key)
        my_bucket = s3.buckets[config.bucket_name]
        f = my_bucket.objects[key]
        f.write(Pathname.new("messages/#{key}"))
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
        rescue ::JSON::ParserError, TypeError
          message_object.body
        end
      end
      private :raw_body_with_sns_check
    end
  end
end
