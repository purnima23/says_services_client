require 'spec_helper'

describe SaysServicesClient::Models::Campaigns::StateConcerns do
  describe '#abandoned?' do
    it "should return true if state is 'abandoned'" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('abandoned')
      c.abandoned?.should be_true
    end
    
    it "should return false" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('live')
      c.abandoned?.should be_false
    end
  end
  
  describe '#draft?' do
    it "should return true if state is 'draft'" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('draft')
      c.draft?.should be_true
    end
    
    it "should return false" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('live')
      c.draft?.should be_false
    end
  end
  
  describe '#ready?' do
    it "should return true if state is 'ready'" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('ready')
      c.ready?.should be_true
    end
    
    it "should return false" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('live')
      c.ready?.should be_false
    end
  end
  
  describe '#paused?' do
    it "should return true if state is 'paused'" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('paused')
      c.paused?.should be_true
    end
    
    it "should return false" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('live')
      c.paused?.should be_false
    end
  end
  
  describe '#scheduled?' do
    it "should return true if state is 'scheduled'" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('scheduled')
      c.scheduled?.should be_true
    end
    
    it "should return false" do
      c = SaysServicesClient::Campaign.new
      c.stub(:state).and_return('live')
      c.scheduled?.should be_false
    end
  end
end