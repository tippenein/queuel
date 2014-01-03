require "forwardable"
module Queuel
  module SNS
    class Engine < Base::Engine
      extend Forwardable
      def_delegators :Queuel, :logger

      AWSSDKMissingError = Class.new(StandardError)

      private

      def client_klass
        if defined?(::AWS::SNS)
          ::AWS::SNS
        else
          begin
            logger.info "Loading AWS SDK..."
            require 'aws-sdk'
            ::AWS::SNS
          rescue LoadError
            logger.error "Couldn't find aws_sdk gem"
            raise(AWSSDKMissingError)
          end
        end
      end
    end
  end
end
