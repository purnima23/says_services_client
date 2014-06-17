require 'spec_helper'

describe SaysServicesClient::Models::Campaigns::ShareConcerns do
  context '#include_request_share_by_user_id' do
    it 'includes share to campaign' do
      VCR.use_cassette 'Models/Campaigns/ShareConcernsTest/include_request_share_by_user_id_23' do
        campaign = SaysServicesClient::Campaign.new(id: 3)
        SaysServicesClient::Campaign.include_request_share_by_user_id('my', 23, [campaign])
        campaign.share_by_user_id(23).should_not be_nil
      end
    end
  end
  
  context '#campaigns_shares_mapping' do
    it 'sets instance variable @shares for campaigns' do
      campaigns = 2.times.collect {|x| double("campaign", id: x+1)}
      shares = [(double("share", campaign_id: 2))]
      
      SaysServicesClient::Campaign.send(:campaigns_shares_mapping, campaigns, shares)
      campaigns.first.instance_variable_get("@shares").should be_empty
      campaigns.last.instance_variable_get("@shares").should_not be_empty
    end
  end
  
  context '#request_share_by_user_id' do
    it 'accepts campaign id' do
      SaysServicesClient::Share.should_receive(:find_by_user_id).with(23, campaign_ids: [12], country: 'my')
      SaysServicesClient::Campaign.send(:request_share_by_user_id, 'my', 23, 12)
    end
    
    it 'accepts array of campaign id' do
      SaysServicesClient::Share.should_receive(:find_by_user_id).with(23, campaign_ids: [12], country: 'my')
      SaysServicesClient::Campaign.send(:request_share_by_user_id, 'my', 23, [12])
    end
  end
    
  context '#share_by_user_id' do
    it 'returns share from instance variable @shares' do
      campaign = SaysServicesClient::Campaign.new(id: 12)
      share = double("share", campaign_id: 12, user_id: 23)
      campaign.instance_variable_set("@shares", [share])
      
      campaign.share_by_user_id(23).should eq(share)
      campaign.share_by_user_id(123).should be_nil
    end
  end
end