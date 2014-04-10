require 'spec_helper'

describe SaysServicesClient::Models::Shares::ApiServiceConcerns do
  context '#find_by_user_id_path' do
    it 'appends campaign_ids to URL if present in hash as integer' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: 2)
      path.should eq("/api/v2/shares/users/23?campaign_ids=2")
    end
    
    it 'appends campaign_ids to URL if present in hash as array' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: [1,2,3])
      path.should eq("/api/v2/shares/users/23?campaign_ids=1,2,3")
    end
    
    it 'should not append campaign_ids to URL if not present' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, {})
      path.should eq("/api/v2/shares/users/23")
    end
  end
  
  context '#find_by_user_id' do
    context 'with block given' do
      it 'returns correct share without campaign_ids' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_23' do
          SaysServicesClient::Share.find_by_user_id(23) do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
      end
      
      it 'returns correct share with campaign_ids' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_23_campaign_ids_12' do
          SaysServicesClient::Share.find_by_user_id(23, campaign_ids: 12) do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
        @shares.first.campaign_id.should eq(12)
      end
      
      it 'returns empty if no shares found' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_empty' do
          SaysServicesClient::Share.find_by_user_id(9283123123) do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.should be_empty
      end
    end
    
    context 'without block given' do
      it 'returns correct share without campaign_ids' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_23' do
          @shares = SaysServicesClient::Share.find_by_user_id(23)
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
      end
      
      it 'returns correct share with campaign_ids' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_23_campaign_ids_12' do
          @shares = SaysServicesClient::Share.find_by_user_id(23, campaign_ids: 12)
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
        @shares.first.campaign_id.should eq(12)
      end
      
      it 'returns empty if no shares found' do
        VCR.use_cassette 'ShareTest_#find_by_user_id_empty' do
          @shares = SaysServicesClient::Share.find_by_user_id(9283123123)
        end
        @shares.should be_empty
      end
    end
  end
end