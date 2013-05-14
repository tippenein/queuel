module Queuel
  module Null
    class Engine
      def initialize(*)
      end

      def queue(*)
        Queue.new
      end
    end
  end
end
