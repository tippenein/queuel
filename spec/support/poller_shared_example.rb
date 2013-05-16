shared_examples "a poller" do
  let(:message) { double "message" }
  let(:queue) { double "Queue", peek: [] }
  let(:block) { lambda{|m| } }
  let(:thread_count) { 1 }
  let(:options) { {} }

  subject do
    described_class.new thread_count, queue, options, block
  end

  it { should respond_to :poll }

  describe "profiling", profile: true do
    let(:messages) do
      1000.times.inject([]) { |a,_| a += message }
    end

    before do
      message.stub delete: true
      subject.stub quit_on_empty?: true
      subject.stub sleep_time: 0
      subject.stub(:pop_new_message).and_return(message, nil)
    end

    describe "with 1 thread" do
      let(:thread_count) { 1 }
      before do
        queue.stub(:peek).and_return *([message] * 100), nil
      end

      it "can poll" do
        not_for_null do
          subject.poll
        end
      end
    end

    describe "with 4 threads" do
      let(:thread_count) { 4 }
      before do
        queue.stub(:peek).and_return *([message, message, message, message] * (100/4)), nil
      end

      it "can poll" do
        not_for_null do
          subject.poll
        end
      end
    end
  end

  describe "limited loops" do
    describe "with 2 yields, one nil" do
      before do
        subject.stub quit_on_empty?: true
        subject.stub sleep_time: 0
        queue.stub(:peek).and_return [1], nil
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
  end
end
