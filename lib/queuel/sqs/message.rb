module Queuel
  module SQS
    class Message < Base::Message
      # sqs has a limit of 64kb, 40 is arbitrary number to compensate for
      # space the hashes take up
      MAX_BYTESIZE=40*1024
      # if message_object exists (not nil), receive the data, otherwise push
      def raw_body
        # set based on whether pushing or receiving
        if @raw_body
          @raw_body
        else
          message_object.nil? ? push_message : pull_message
        end
      end

      def push_message
        # encoded body is just the json string
        if encoded_body.bytesize > MAX_BYTESIZE
          key = SecureRandom.urlsafe_base64
          write_to_s3 encoded_body key
          self.body = { 'queuel_s3_object' => key }
        end
        encoded_body
      end

      def pull_message
        begin
          decoded_body = JSON.parse(message_object.body)
          if decoded_body.key?('queuel_s3_object')
            read_from_s3 decoded_body[:queuel_s3_object]
          else
            message_object.body
          end
        rescue ::JSON::ParserError, TypeError
          # if message_object.body isn't a json string
          raw_body_with_sns_check
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

      # things written to s3 are expired automatically after 60 days
      # so there is no need to manually garbage collect them.
      def write_to_s3 (message, key)
        begin
          my_bucket = s3.buckets[options[:bucket_name]]
          my_bucket.objects[key].write(message)
        rescue
          raise BucketDoesNotExistError "Bucket has either expired or does not exist"
        end
      end

      class BucketDoesNotExistError < StandardError
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
