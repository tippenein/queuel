require 'forwardable'
module Queuel
  module Null
    class Message
      def initialize(id, body, queue = nil)
        self.id = id
        self.body = body
        self.queue = queue
      end

      attr_reader :id
      attr_reader :queue
      attr_reader :body

      private
      attr_writer :id
      attr_writer :queue
      attr_writer :body
    end
  end
end
