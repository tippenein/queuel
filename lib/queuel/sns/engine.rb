require "queuel/aws_constant_finder"
module Queuel
  module SNS
    class Engine < Base::Engine
      private

      def client_klass
        AWSConstantFinder.find(:sns)
      end
    end
  end
end
