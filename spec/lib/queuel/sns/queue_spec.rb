require 'spec_helper'
module Queuel
  module SNS
    describe Queue do
      let(:queue_object_with_message) { double "QueueObject", get: message, peek: [message] }
      let(:queue_object_with_nil_message) { double "QueueObject", get: nil, peek: nil }
      let(:message) { double "Message", body: "uhuh" }
      let(:client) { double "ClientObject" }
      let(:name) { "venues queue" }

      subject do
        described_class.new client, name
      end

      it { should respond_to :push }
    end
  end
end
