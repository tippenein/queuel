require 'spec_helper'
module Queuel
  module SNS
    describe Engine do
      it_should_behave_like "an engine"

      describe "getting SNS client" do
        its(:client_klass) { should == ::AWS::SNS }
      end
    end
  end
end
