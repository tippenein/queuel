shared_examples "a message" do
  let(:id) { 1 }
  let(:body) { "test" }
  let(:queue) { nil }
  subject { described_class.new id, body, queue }

  it { should respond_to :id }
  it { should respond_to :body }
  it { should respond_to :queue }

  its(:queue) { should be_nil }
  its(:id) { should == 1 }
  its(:body) { should == 'test' }

  describe "with a given queue" do
    let(:queue) { double "Queue object" }

    its(:queue) { should == queue }
  end
end
