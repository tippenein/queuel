require "queuel/aws_constant_finder"
module Queuel
  module SQS
    class Engine < Base::Engine
      def queue(which_queue)
        memoized_queues[which_queue.to_s] ||= queue_klass.new(client, which_queue, credentials)
      end

      private

      def client_klass
        AWSConstantFinder.find(:sqs)
      end
    end
  end
end
