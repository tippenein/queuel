module Queuel
  module IronMq
    class Poller < Base::Poller
      def built_options
        options.merge default_args # intentional direction, force defaults
      end

      def default_args
        { n: 1 }
      end
    end
  end
end
