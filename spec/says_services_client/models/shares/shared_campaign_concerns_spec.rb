require 'spec_helper'

describe SaysServicesClient::Models::Shares::SharedCampaignConcerns do
  context '#include_shared_campaign' do
    it 'includes campaign to share' do
      share = SaysServicesClient::Share.new(campaign_id: 3, country_code: 'my')
      share2 = SaysServicesClient::Share.new(campaign_id: 12, country_code: 'my')
      VCR.use_cassette 'Models/Shares/SharedCampaignTest/include_shared_campaign' do
        SaysServicesClient::Share.include_shared_campaign('my', [share, share2])
      end
      share.campaign.is_a?(SaysServicesClient::Campaign).should be_true
      share.campaign.should_not be_nil
      share2.campaign.should_not be_nil
    end
  end
  
  context '#shares_campaigns_mapping' do
    it 'sets instance variable @campaign for shares' do
      campaign = SaysServicesClient::Campaign.new(id: 3)
      share = SaysServicesClient::Share.new(campaign_id: 3)
      
      SaysServicesClient::Share.send(:shares_campaigns_mapping, [share], [campaign])
      share.instance_variable_get("@campaign").should_not be_blank
    end
  end

  context '#campaign' do
    it 'should return instance variable @campaign' do
      share = SaysServicesClient::Share.new
      share.instance_variable_set("@campaign", 'ok')
      share.campaign.should eq('ok')
    end
  end
end