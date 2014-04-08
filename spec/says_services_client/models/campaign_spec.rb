require 'spec_helper'

describe SaysServicesClient::Models::Campaign do
  context '#find' do
    it 'should raise error if include share by user id without user_id' do
      VCR.use_cassette 'CampaignTest_#find_12_include_share_by_user_id_23' do
        expect do
          @campaign = SaysServicesClient::Campaign.find(12, include: :share_by_user_id)
        end.to raise_error
      end
    end
    
    context 'with block given' do
      it 'returns correct campaign' do
        VCR.use_cassette 'CampaignTest_#find_11' do
          SaysServicesClient::Campaign.find(11) do |c|
            @campaign = c
          end
          HYDRA.run
        end
        @campaign.id.should eq(11)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'CampaignTest_#find_12_include_share_by_user_id_23' do
          SaysServicesClient::Campaign.find(12, include: :share_by_user_id, user_id: 23) do |c|
            @campaign = c
          end
          HYDRA.run
        end
        @campaign.id.should eq(12)
        @campaign.share_by_user_id(23).should_not be_nil
        @campaign.share_by_user_id(23).is_a?(SaysServicesClient::Share).should be_true
      end
    end
    
    context 'without block given' do
      it 'returns correct campaign' do
        VCR.use_cassette 'CampaignTest_#find_11' do
          @campaign = SaysServicesClient::Campaign.find(11)
        end
        @campaign.id.should eq(11)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'CampaignTest_#find_12_include_share_by_user_id_23' do
          @campaign = SaysServicesClient::Campaign.find(12, include: :share_by_user_id, user_id: 23)
        end
        @campaign.id.should eq(12)
        @campaign.share_by_user_id(23).should_not be_nil
        @campaign.share_by_user_id(23).is_a?(SaysServicesClient::Share).should be_true
      end
    end
  end
  
  context '#all' do
    it 'should raise error if include share by user id without user_id' do
      VCR.use_cassette 'CampaignTest_#all_country_my_include_share_by_user_id_23' do
        expect do
          @campaign = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id)
        end.to raise_error
      end
    end
    
    context 'with block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'CampaignTest_#all' do
          SaysServicesClient::Campaign.all do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'CampaignTest_#all_country_my' do
          SaysServicesClient::Campaign.all(country: 'my') do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'CampaignTest_#all_country_my_include_share_by_user_id_23' do
          SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: 23) do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(3)
        @campaigns.each do |c|
          # campaign id: 12 has a share of user_id: 23
          if c.id == 12
            c.share_by_user_id(23).should_not be_nil
          else
            c.share_by_user_id(23).should be_nil
          end
        end
      end
    end
    
    context 'without block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'CampaignTest_#all' do
          @campaigns = SaysServicesClient::Campaign.all
        end
        @campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'CampaignTest_#all_country_my' do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my')
        end
        @campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'CampaignTest_#all_country_my_include_share_by_user_id_23' do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: 23)
          HYDRA.run
        end
        @campaigns.size.should eq(3)
        @campaigns.each do |c|
          # campaign id: 12 has a share of user_id: 23
          if c.id == 12
            c.share_by_user_id(23).should_not be_nil
          else
            c.share_by_user_id(23).should be_nil
          end
        end
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
      SaysServicesClient::Share.should_receive(:find_by_user_id).with(23, campaign_ids: [12])
      SaysServicesClient::Campaign.send(:request_share_by_user_id, 23, 12)
    end
    
    it 'accepts array of campaign id' do
      SaysServicesClient::Share.should_receive(:find_by_user_id).with(23, campaign_ids: [12])
      SaysServicesClient::Campaign.send(:request_share_by_user_id, 23, [12])
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