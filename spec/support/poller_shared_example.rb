shared_examples "a poller" do
  let(:message) { double "message" }
  let(:queue) { double "Queue" }
  let(:block) { lambda{|m| } }
  let(:options) { {} }

  subject do
    described_class.new queue, options, block
  end

  it { should respond_to :poll }

  describe "nil loops" do
    describe "break on nil" do
      before do
        subject.stub break_if_nil?: true
        subject.stub sleep_time: 0
        subject.stub pop_new_message: nil
      end

      it "can poll" do
        subject.should_receive(:sleep).exactly(1).times
        subject.poll
      end
    end

    describe "with max fails" do
      before do
        subject.stub max_fails: 10
        subject.stub(:pop_new_message).and_return(*([nil] * 15))
      end

      it "can poll" do
        subject.should_receive(:sleep).exactly(10).times
        subject.poll
      end
    end

    describe "with timeout" do
      before do
        subject.stub timeout: 0.1
        subject.stub(:pop_new_message).and_return(*([nil] * 1500))
      end

      it "can poll" do
        subject.should_receive(:sleep).at_least(10).times
        subject.poll
      end
    end
  end

  describe "limited loops" do
    describe "with 2 yields, one nil" do
      before do
        subject.stub break_if_nil?: true
        subject.stub sleep_time: 0
        subject.stub(:pop_new_message).and_return(message, nil)
      end

      it "can poll" do
        not_for_null do
          block.should_receive(:call).once
          message.should_receive(:delete)
          subject.poll
        end
      end
    end

    describe "with timeout" do
      before do
        subject.stub timeout: 0.1
        subject.stub(:pop_new_message).and_return(message, *([nil] * 1500))
      end

      it "can poll" do
        not_for_null do
          block.should_receive(:call).once
          message.should_receive(:delete)
          subject.should_receive(:sleep).at_least(10).times
          subject.poll
        end
      end
    end

    describe "with max fails" do
      before do
        subject.stub max_fails: 10
        subject.stub(:pop_new_message).and_return(message, *([nil] * 15))
      end

      it "can poll" do
        not_for_null do
          block.should_receive(:call).once
          message.should_receive(:delete)
          subject.should_receive(:sleep).exactly(10).times
          subject.poll
        end
      end
    end
  end
end
