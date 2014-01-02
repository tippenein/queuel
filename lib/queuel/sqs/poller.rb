module Queuel
  module SQS
    class Poller < Base::Poller
      # Public: poll
      private

      def built_options
        options.merge default_options # intentional direction, force defaults
      end

      def default_options
        { n: 1 }
      end

      def peek_options
        { n: self.workers }
      end

      def queue_size
        queue.approximate_number_of_messages
      end
    end
  end
end
