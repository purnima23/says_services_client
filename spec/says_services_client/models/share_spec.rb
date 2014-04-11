require 'spec_helper'

describe SaysServicesClient::Models::Share do
  describe 'validation' do
    before(:each) do
      @share = SaysServicesClient::Share.new
    end
    
    it 'should require user_id on create' do
      @share.valid?.should be_false
      @share.errors.messages[:user_id].should_not be_blank
    end
    
    it 'should require campaign_id on create' do
      @share.valid?.should be_false
      @share.errors.messages[:campaign_id].should_not be_blank
    end
    
    it 'should require username on create' do
      @share.valid?.should be_false
      @share.errors.messages[:username].should_not be_blank
    end
    
    it 'should require message on create' do
      @share.valid?.should be_false
      @share.errors.messages[:message].should_not be_blank
    end
  end
end