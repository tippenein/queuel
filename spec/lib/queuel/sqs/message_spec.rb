require 'spec_helper'
require 'json'
require 'aws-sdk'
module Queuel
  module SQS
    describe Message do
      it_should_behave_like "a message"
      describe "initialization with SQS Object" do
        let(:queue_double) { double "Queue" }
        let(:body) { "body" }
        let(:message_object) { double "SQSMessage", id: 1, body: body, queue: queue_double }
        subject { described_class.new(message_object) }

        before do
          subject.stub decode_body?: false
          message_object.stub(:as_sns_message).and_raise ::JSON::ParserError
          Queuel.configure { engine :sqs }
        end

        its(:id) { should == 1 }
        its(:body) { should == "body" }
        its(:queue) { should == queue_double }

        describe "when pulling an oversized message" do
          let(:body) { '{"queuel_s3_object": "whatever" }' }

          it "should call read_from_s3" do
            subject.should_receive(:read_from_s3)
            subject.raw_body
          end
        end

        describe "#s3" do
          subject { described_class.new(message_object, {
            :access_token => "stuff",
            :secret_access_token => "derp" }) }
          it "sets the s3 object" do
            subject.should_receive(:s3, { :access_token => "stuff", :secret_access_token => "derp" } )
            subject.s3
          end
        end

        describe "when pushing an oversized json hash" do
          before do
            subject.send("message_object=", nil)
            subject.stub(:encoded_body).and_return double("body", bytesize: subject.max_bytesize+1)
          end
          it "should call write_to_s3" do
            subject.should_receive(:write_to_s3)
            subject.raw_body
          end
        end

        describe "with json" do
          let(:body) { '{"username":"jon"}' }
          before do
            subject.stub decode_body?: true
          end

          its(:body) { should == { username: "jon" } }
          its(:raw_body) { should == body }
        end

        describe "with valid SNS message" do
          let(:sns_body) { "Hello From SNS" }
          before do
            message_object.stub(:as_sns_message).and_return double("SNSMessage", body: sns_body)
          end
          its(:raw_body) { should == sns_body }
          its(:raw_body) { should_not == message_object.body}

          describe "which is json" do
            let(:sns_body) { '{"username":"jon"}' }
            before do
              subject.stub decode_body?: true
              message_object.stub(:as_sns_message).and_return double("SNSMessage", body: sns_body)
            end

            its(:body) { should == { username: "jon" } }
            its(:raw_body) { should == sns_body }
          end
        end
      end

      describe "using message for encoding" do
        subject { described_class.new }

        describe "setting the body" do
          let(:hash_json) { { username: "jon" } }
          let(:string_json) { '{"username":"jon"}' }

          before do
            subject.body = body
          end

          describe "valid json hash" do
            let(:body) { hash_json }

            its(:body) { should == hash_json }
            its(:raw_body) { should == string_json }
          end
        end

        describe "setting the raw body" do
          let(:hash_json) { { username: "jon" } }
          let(:string_json) { '{"username":"jon"}' }

          before do
            subject.raw_body = raw_body
          end

          describe "valid json string" do
            let(:raw_body) { string_json }

            its(:body) { should == hash_json }
            its(:raw_body) { should == raw_body }
          end

          describe "valid json hash" do
            let(:raw_body) { hash_json }

            its(:body) { should == hash_json }
            its(:raw_body) { should == raw_body }
          end
        end
      end
    end
  end
end
