require 'spec_helper'
module Queuel
  module Null
    describe Queue do
      let(:null) { true }
      it_should_behave_like "a queue"
    end
  end
end
