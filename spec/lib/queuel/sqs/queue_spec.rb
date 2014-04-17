require 'spec_helper'
module Queuel
  module SQS
    describe Queue do
      let(:message) { double "Message", body: "uhuh" }
      let(:client) { double "ClientObject" }
      let(:name) { "venues queue" }
      let(:credentials) {{ access_key: "none", secret_access_key: "none" }}
      let(:queue_object_with_message) { double "QueueObject", get: message, receive_message: message }
      let(:queue_object_with_nil_message) { double "QueueObject", get: nil, receive_message: nil }

      subject do
        described_class.new client, name, credentials
      end

      before do
        message.stub_chain :as_sns_message, body: "uhuh"
        client.stub_chain :queues, named: queue_object_with_message
      end

      it_should_behave_like "a queue"

      describe "size" do
        it "should check the queue_connection's approximate_number_of_messages for size" do
          queue_object_with_message.should_receive :approximate_number_of_messages
          subject.size
        end
      end

      describe "push" do
        before do
          queue_object_with_message.should_receive(:send_message)
                                   .with('foobar')
        end

        it "receives a call to build message with the credentials" do
          subject.should_receive(:build_push_message)
                 .with("foobar", credentials)
                 .and_return('foobar')

          subject.push "foobar"
        end

        it "merges options that are passed in" do
          subject.should_receive(:build_push_message)
                 .with("foobar", {:foo => 'bar'}.merge(credentials))
                 .and_return('foobar')

          subject.push "foobar", :foo => 'bar'
        end
      end
    end
  end
end
