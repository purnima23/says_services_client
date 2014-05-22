require 'spec_helper'

describe SaysServicesClient::Models::Campaigns::ApiServiceConcerns do
  context '#find' do
    context 'include_share_by_user_id' do
      it 'should raise error if include share by user id without user_id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_12_include_share_by_user_id_23' do
          expect do
            @campaign = SaysServicesClient::Campaign.find(12, include: :share_by_user_id)
          end.to raise_error
        end
      end
      
      it 'should ignore include_share_by_user_id request if user_id is blank' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_12_include_share_by_user_id_blank' do
          SaysServicesClient::Campaign.find(12, include: :share_by_user_id, user_id: nil) do |c|
            @campaign = c
          end
          HYDRA.run
        end
        @campaign.instance_variable_get("@shares").should be_nil
      end
    end
    
    context 'with block given' do
      it 'returns correct campaign' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_11' do
          SaysServicesClient::Campaign.find(11) do |c|
            @campaign = c
          end
          HYDRA.run
        end
        @campaign.id.should eq(11)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_12_include_share_by_user_id_23' do
          SaysServicesClient::Campaign.find(12, include: :share_by_user_id, user_id: 23) do |c|
            @campaign = c
          end
          HYDRA.run
        end
        @campaign.id.should eq(12)
        @campaign.instance_variable_get("@shares").should_not be_nil
        @campaign.share_by_user_id(23).should_not be_nil
        @campaign.share_by_user_id(23).is_a?(SaysServicesClient::Share).should be_true
      end
    end
    
    context 'without block given' do
      it 'returns correct campaign' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_11' do
          @campaign = SaysServicesClient::Campaign.find(11)
        end
        @campaign.id.should eq(11)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/find_12_include_share_by_user_id_23' do
          @campaign = SaysServicesClient::Campaign.find(12, include: :share_by_user_id, user_id: 23)
        end
        @campaign.id.should eq(12)
        @campaign.instance_variable_get("@shares").should_not be_nil
        @campaign.share_by_user_id(23).should_not be_nil
        @campaign.share_by_user_id(23).is_a?(SaysServicesClient::Share).should be_true
      end
    end
  end
  
  context '#all' do
    it 'should not run #include_request_share_by_user_id if campaigns is empty' do
      VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_in_include_share_by_user_id_1' do
        SaysServicesClient::Campaign.should_not_receive(:include_request_share_by_user_id)
        @campaigns = SaysServicesClient::Campaign.all(country: 'in', include: :share_by_user_id, user_id: 1)
      end
      @campaigns.size.should eq(0)
    end      
    
    context 'with ids' do
      it 'should returns campaigns in ids' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_with_ids_3_12' do
          @campaigns = SaysServicesClient::Campaign.all(ids: [3, 12])
        end
        @campaigns.size.should eq(2)
        @campaigns.first.id.should eq(3)
        @campaigns.last.id.should eq(12)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_with_ids_11_12_include_share_by_user_id_23' do
          SaysServicesClient::Campaign.all(ids: [11,12], include: :share_by_user_id, user_id: 23) do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(2)
        @campaigns.each do |c|
          c.instance_variable_get("@shares").should_not be_nil
          # campaign id: 12 has a share of user_id: 23
          if c.id == 12
            c.share_by_user_id(23).should_not be_nil
          else
            c.share_by_user_id(23).should be_nil
          end
        end
      end
    end
    
    context 'include_share_by_user_id' do
      it 'should raise error if include share by user id without user_id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          expect do
            @campaign = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id)
          end.to raise_error
        end
      end
      
      it 'should ignore include_share_by_user_id request if user_id is blank' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_blank' do
          SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: nil) do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.each do |c|
          c.instance_variable_get("@shares").should be_nil
        end
      end
    end
    
    context 'with block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all' do
          SaysServicesClient::Campaign.all do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my' do
          SaysServicesClient::Campaign.all(country: 'my') do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: 23) do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(3)
        @campaigns.each do |c|
          c.instance_variable_get("@shares").should_not be_nil
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
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all' do
          @campaigns = SaysServicesClient::Campaign.all
        end
        @campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my' do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my')
        end
        @campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: 23)
        end
        @campaigns.size.should eq(3)
        @campaigns.each do |c|
          c.instance_variable_get("@shares").should_not be_nil
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
  
  context '#all_path' do
    it 'appends ids to URL if present in hash as integer' do
      path = SaysServicesClient::Campaign.send(:all_path, ids: 2)
      path.should eq("/api/v2/campaigns?ids=2")
    end
    
    it 'appends ids to URL if present in hash as array' do
      path = SaysServicesClient::Campaign.send(:all_path, ids: [1,2,3])
      path.should eq("/api/v2/campaigns?ids=1,2,3")
    end
    
    it 'should not append campaign_ids to URL if not present' do
      path = SaysServicesClient::Campaign.send(:all_path, {})
      path.should eq("/api/v2/campaigns")
    end
  end
  
  context '#recommendations_for_user' do
    context 'with block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/recommendations_for_user_28' do
          SaysServicesClient::Campaign.recommendations_for_user(28, {country: 'my'}) do |c|
            @campaigns = c
          end
          HYDRA.run
        end
        @campaigns.size.should eq(3)
        @campaigns.map(&:id).should eq([2,12,13])
      end
    end
    
    context 'without block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'Models/Campaigns/ApiServiceConcernsTest/recommendations_for_user_23' do
          @campaigns = SaysServicesClient::Campaign.recommendations_for_user(23, {country: 'my'})
        end
        @campaigns.size.should eq(4)
        @campaigns.map(&:id).should eq([2,3,12,13])
      end
    end
  end
end