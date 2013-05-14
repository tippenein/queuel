require 'spec_helper'
module Queuel
  module Null
    describe Message do
      let(:null) { true }
      it_should_behave_like "a message"
    end
  end
end
