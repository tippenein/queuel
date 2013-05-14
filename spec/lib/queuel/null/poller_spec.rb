require 'spec_helper'
module Queuel
  module Null
    describe Poller do
      let(:null) { true }
      it_should_behave_like "a poller"
    end
  end
end
