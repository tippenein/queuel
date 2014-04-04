require 'spec_helper'
module Queuel
  module SQS
    describe Queue do
      let(:queue_object_with_message) { double "QueueObject", get: message, receive_message: message }
      let(:queue_object_with_nil_message) { double "QueueObject", get: nil, receive_message: nil }

      before do
        message.stub_chain :as_sns_message, body: "uhuh"
      end

      it_should_behave_like "a queue"
    end
  end
end
