require 'spec_helper'
module Queuel
  module IronMq
    describe Message do
      it_should_behave_like "a message"
      describe "initialization with Iron Object" do
        let(:queue_double) { double "Queue" }
        let(:message_object) { double "IronMessage", id: 1, body: "body", queue: queue_double }
        subject { described_class.new(message_object) }

        before do
          subject.stub decode_body?: false
        end

        its(:id) { should == 1 }
        its(:body) { should == "body" }
        its(:queue) { should == queue_double }
        its(:decode_by_default?) { should be_true }
        its(:decoder) { should == Serialization::Json::Decoder }
        its(:encode_by_default?) { should be_true }
        its(:encoder) { should == Serialization::Json::Encoder }
      end
    end
  end
end
