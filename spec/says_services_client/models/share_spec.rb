require 'spec_helper'

describe SaysServicesClient::Models::Share do
  describe 'validation' do
    it 'should require username on create' do
      share = SaysServicesClient::Share.new
      share.valid?.should be_false
      share.errors.messages[:username].should_not be_blank
    end
  end
end