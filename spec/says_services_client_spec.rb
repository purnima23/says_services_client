require 'spec_helper'

describe SaysServicesClient do
  describe 'Campaign' do
    it 'is kind of Models::Campaign' do
      SaysServicesClient::Campaign.new.is_a?(SaysServicesClient::Models::Campaign).should be_true
    end
  end
  
  describe 'Campaign' do
    it 'is kind of Models::Share' do
      SaysServicesClient::Share.new.is_a?(SaysServicesClient::Models::Share).should be_true
    end
  end
end