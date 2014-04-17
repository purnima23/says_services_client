require 'spec_helper'

describe SaysServicesClient::Campaign do
  describe '#triggers=' do
    it 'wraps trigger as class' do
      campaign = SaysServicesClient::Campaign.new
      campaign.triggers = [{id: 1, message: 'wrapper'}]
      campaign.triggers.is_a?(Array).should be_true
      campaign.triggers.first.is_a?(SaysServicesClient::Trigger).should be_true
      campaign.triggers.first.id.should eq(1)
    end
  end
end