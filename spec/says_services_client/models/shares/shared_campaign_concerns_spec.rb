require 'spec_helper'

describe SaysServicesClient::Models::Shares::SharedCampaignConcerns, :vcr do
  context '#include_shared_campaign' do
    it 'includes campaign to share' do
      share = SaysServicesClient::Share.new(campaign_id: 3, country_code: 'my')
      share2 = SaysServicesClient::Share.new(campaign_id: 12, country_code: 'my')
      SaysServicesClient::Share.send(:include_campaign, [share, share2], country: 'my')
      share.campaign.is_a?(SaysServicesClient::Campaign).should be_true
      share.campaign.should_not be_nil
      share2.campaign.should_not be_nil
    end
  end
  
  context '#shares_campaigns_mapping' do
    it 'sets campaign for shares' do
      campaign = SaysServicesClient::Campaign.new(id: 3)
      share = SaysServicesClient::Share.new(campaign_id: 3)
      
      SaysServicesClient::Share.send(:shares_campaigns_mapping, [share], [campaign])
      share.campaign.should_not be_blank
    end
  end

  context '#campaign' do
    it 'should return campaign' do
      share = SaysServicesClient::Share.new
      share.campaign = 'ok'
      share.campaign.should eq('ok')
    end
  end
end