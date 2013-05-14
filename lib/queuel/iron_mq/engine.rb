module Queuel
  module IronMq
    class Engine < Base::Engine
      IronMqMissingError = Class.new(StandardError)

      def try_typhoeus
        require 'typhoeus'
      rescue LoadError
        false
      end

      def client_klass
        if defined?(::IronMQ::Client)
          try_typhoeus
          ::IronMQ::Client
        else
          begin
            require 'iron_mq'
            ::IronMQ::Client
          rescue LoadError
            raise(IronMqMissingError)
          end
        end
      end
    end
  end
end
