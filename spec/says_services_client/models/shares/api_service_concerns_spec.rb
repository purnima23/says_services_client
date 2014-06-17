require 'spec_helper'

describe SaysServicesClient::Models::Shares::ApiServiceConcerns do  
  context '#find_by_user_id_path' do
    it 'appends campaign_ids to URL if present in hash as integer' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: 2, country: 'my')
      path.should eq("/my/api/v2/shares/users/23?campaign_ids=2")
    end
    
    it 'appends campaign_ids to URL if present in hash as array' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: [1,2,3], country: 'my')
      path.should eq("/my/api/v2/shares/users/23?campaign_ids=1,2,3")
    end
    
    it 'should not append campaign_ids to URL if not present' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, country: 'my')
      path.should eq("/my/api/v2/shares/users/23")
    end
  end
  
  context '#find_by_user_id' do
    it 'should not run #include_shared_campaign if shares is empty' do
      VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_empty' do
        SaysServicesClient::Share.should_not_receive(:include_shared_campaign)
        @shares = SaysServicesClient::Share.find_by_user_id(9283123123, include: :campaign, country: 'my')
      end
      @shares.should be_empty
    end      
    
    context 'with block given' do
      it 'returns correct share without campaign_ids' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_23' do
          SaysServicesClient::Share.find_by_user_id(23, country: 'my') do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
      end
      
      it 'returns correct share with campaign_ids' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_23_campaign_ids_12' do
          SaysServicesClient::Share.find_by_user_id(23, campaign_ids: 12, country: 'my') do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
        @shares.first.campaign_id.should eq(12)
      end
      
      it 'returns empty if no shares found' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_empty' do
          SaysServicesClient::Share.find_by_user_id(9283123123, country: 'my') do |s|
            @shares = s
          end
          HYDRA.run
        end
        @shares.should be_empty
      end
    end
    
    context 'without block given' do
      it 'returns correct share without campaign_ids' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_23' do
          @shares = SaysServicesClient::Share.find_by_user_id(23, country: 'my')
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
      end
      
      it 'returns correct share with campaign_ids' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_23_campaign_ids_12' do
          @shares = SaysServicesClient::Share.find_by_user_id(23, campaign_ids: 12, country: 'my')
        end
        @shares.size.should eq(1)
        @shares.first.user_id.should eq(23)
        @shares.first.campaign_id.should eq(12)
      end
      
      it 'returns empty if no shares found' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_by_user_id_empty' do
          @shares = SaysServicesClient::Share.find_by_user_id(9283123123, country: 'my')
        end
        @shares.should be_empty
      end
    end
  end

  context '#find' do
    context 'with block given' do
      it 'returns correct share with id' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_46' do
          SaysServicesClient::Share.find(46, country: 'my') do |s|
            @share = s
          end
          HYDRA.run
        end
        @share.id.should eq(46)
      end
      
      it 'returns empty if no shares found' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_9283123123' do
          SaysServicesClient::Share.find(9283123123, country: 'my') do |s|
            @share = s
          end
          HYDRA.run
        end
        @share.should be_nil
      end
    end
    
    context 'without block given' do
      it 'returns correct share id' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_46' do
          @share = SaysServicesClient::Share.find(46, country: 'my')
        end
        @share.id.should eq(46)
      end
            
      it 'returns empty if no shares found' do
        VCR.use_cassette 'Models/Shares/ApiServiceConcernsTest/find_9283123123' do
          @share = SaysServicesClient::Share.find(9283123123, country: 'my')
        end
        @share.should be_nil
      end
    end
  end
end