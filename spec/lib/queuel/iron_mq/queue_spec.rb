require 'spec_helper'
module Queuel
  module IronMq
    describe Queue do
      let(:message) { double "Message" }
      let(:queue_object) { double "QueueObject" }
      let(:client) { double "ClientObject", queue: queue_object }
      let(:name) { "venues queue" }
      subject do
        described_class.new client, name
      end

      # Poller object handles this
      it { should respond_to :receive }

      describe "push" do
        it "posts via client" do
          queue_object.should_receive(:post)
          subject.push
        end
      end

      describe "pop" do
        describe "with messages" do
          before do
            queue_object.should_receive(:get).and_return message
          end

          it "should simply return a message" do
            subject.pop.should == message
          end

          it "should delete after bolck" do
            message.should_receive(:delete)
            subject.pop { |m| m }
          end
        end

        describe "with nil message" do
          before do
            queue_object.should_receive(:get).and_return nil
          end

          it "should simply return a message" do
            subject.pop.should == nil
          end

          it "should delete after bolck" do
            subject.pop { |m| m } # basically, don't error
          end
        end
      end
    end
  end
end
