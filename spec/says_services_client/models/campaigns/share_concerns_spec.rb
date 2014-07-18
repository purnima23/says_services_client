require 'spec_helper'

describe SaysServicesClient::Models::Campaigns::ShareConcerns, :vcr do
  context '#include_request_share_by_user_id' do
    it 'includes share to campaign' do
      campaign = SaysServicesClient::Campaign.new(id: 12)
      SaysServicesClient::Campaign.include_request_share_by_user_id('my', 3, [campaign])
      campaign.share_by_user_id(3).should_not be_nil
    end
  end
  
  context '#campaigns_shares_mapping' do
    it 'sets shares for campaigns' do
      campaigns = 2.times.collect {|x| Hashie::Mash.new(id: x+1)}
      shares = [(Hashie::Mash.new(campaign_id: 2))]
      
      SaysServicesClient::Campaign.send(:campaigns_shares_mapping, campaigns, shares)
      campaigns.first.shares.should be_empty
      campaigns.last.shares.should_not be_empty
    end
  end
  
  context '#request_share_by_user_id' do
    it 'accepts array of campaign id' do
      SaysServicesClient::Share.should_receive(:find_by_user_id).with(23, campaign_ids: [12], country: 'my')
      SaysServicesClient::Campaign.send(:request_share_by_user_id, 'my', 23, [12])
    end
  end
    
  context '#share_by_user_id' do
    it 'returns share from shares' do
      campaign = SaysServicesClient::Campaign.new(id: 12)
      share = double("share", campaign_id: 12, user_id: 23)
      campaign.shares = [share]
      
      campaign.share_by_user_id(23).should eq(share)
      campaign.share_by_user_id(123).should be_nil
    end
  end
end