module Queuel
  module SQS
    class Message < Base::Message
      # if message_object exists (not nil), receive the data, otherwise push
      def raw_body
        @raw_body = if message_object
          message = JSON.parse(raw_body_with_sns_check)
          if message.key?('queuel_s3_object')
            read_from_s3 message[:queuel_s3_object]
          else
            message_object
          end
        else
          # sqs has a limit of 64kb, 40 is arbitrary number to compensate for
          # space the hashes take up
          if encoded_body.bytesize > 40*1024
            key = SecureRandom.urlsafe_base64
            write_to_s3 message key
            self.body = { 'queuel_s3_object' => key }
            encoded_body
          end

          encoded_body
        end
      end

      def self.s3
        @s3 ||= get_s3
      end

      def self.get_s3
        AWS::S3.new(
          :access_key_id => options[:access_token],
          :secret_access_key => options[:secret_access_token] )
      end

      def read_from_s3 key
        object = s3.buckets[options[:bucket_name]].objects[key]
        object.read
      end

      def write_to_s3 (message, key)
        my_bucket = s3.buckets[options[:bucket_name]]
        object = my_bucket.objects[key]
        object.write(Pathname.new(key))
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
