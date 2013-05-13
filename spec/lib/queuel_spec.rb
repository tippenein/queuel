require 'spec_helper'
describe Queuel do
  it { should respond_to :engine }
  it { should respond_to :configure }
  it { should respond_to :config }

  it { should respond_to :push }
  it { should respond_to :pop }
  it { should respond_to :<< }
  it { should respond_to :receive }

  describe "configuration" do
    before do
      subject.configure do
        credentials username: "jon"
      end
    end

    it "set the credentials" do
      subject.config.credentials.should == { username: "jon" }
    end
  end
end
