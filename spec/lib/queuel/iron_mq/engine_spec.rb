require 'spec_helper'
module Queuel
  module IronMq
    describe Engine do
      let(:client_object) { double "Client Object" }
      let(:client) { double "Iron MQ Client", new: client_object }

      before do
        subject.stub client_proper: client
      end

      it { should respond_to :queue }

      it "can grab a queue" do
        subject.queue("some_queue").should be_a Queue
      end
    end
  end
end
