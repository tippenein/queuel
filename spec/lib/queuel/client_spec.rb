require 'spec_helper'
module Queuel
  describe Client do
    subject { described_class.new IronMq::Engine, {} }

    it { should respond_to :push }
    it { should respond_to :pop }
    it { should respond_to :receive }
    it { should respond_to :with }

    describe "queue swapping" do
      before do
        Queuel.stub default_queue: "default"
      end

      it "can swap queues easily" do
        subject.queue.should == "default"
        subject.with(:new_queue).queue.should == :new_queue
        subject.queue.should == "default"
      end
    end
  end
end
