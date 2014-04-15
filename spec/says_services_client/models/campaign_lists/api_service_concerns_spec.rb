require 'spec_helper'

describe SaysServicesClient::Models::CampaignLists::ApiServiceConcerns do  
  context '#for' do
    context 'include_share_by_user_id' do
      it 'should raise error if include share by user id without user_id' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          expect do
            @list = SaysServicesClient::CampaignList.for(country: 'my', include: :share_by_user_id)
          end.to raise_error
        end
      end
      
      it 'should ignore include_share_by_user_id request if user_id is blank' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_blank' do
          SaysServicesClient::CampaignList.for(country: 'my', include: :share_by_user_id, user_id: nil) do |c|
            @list = c
          end
          HYDRA.run
        end
        @list.campaigns.each do |c|
          c.instance_variable_get("@shares").should be_nil
        end
      end
    end
    
    context 'with block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all' do
          SaysServicesClient::CampaignList.for do |c|
            @list = c
          end
          HYDRA.run
        end
        @list.campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my' do
          SaysServicesClient::CampaignList.for(country: 'my') do |c|
            @list = c
          end
          HYDRA.run
        end
        @list.campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          SaysServicesClient::CampaignList.for(country: 'my', include: :share_by_user_id, user_id: 23) do |c|
            @list = c
          end
          HYDRA.run
        end
        @list.campaigns.size.should eq(3)
        @list.campaigns.each do |c|
          c.instance_variable_get("@shares").should_not be_nil
          # campaign id: 12 has a share of user_id: 23
          if c.id == 3
            c.share_by_user_id(23).should_not be_nil
          else
            c.share_by_user_id(23).should be_nil
          end
        end
      end
    end
    
    context 'without block given' do
      it 'returns all campaigns' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all' do
          @list = SaysServicesClient::CampaignList.for
        end
        @list.campaigns.size.should eq(4)
      end
    
      it 'returns only MY campaigns if country is specified' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my' do
          @list = SaysServicesClient::CampaignList.for(country: 'my')
        end
        @list.campaigns.size.should eq(3)
      end
      
      it 'can include share by user id' do
        VCR.use_cassette 'Models/CampaignLists/ApiServiceConcernsTest/all_country_my_include_share_by_user_id_23' do
          @list = SaysServicesClient::CampaignList.for(country: 'my', include: :share_by_user_id, user_id: 23)
          HYDRA.run
        end
        @list.campaigns.size.should eq(3)
        @list.campaigns.each do |c|
          c.instance_variable_get("@shares").should_not be_nil
          # campaign id: 12 has a share of user_id: 23
          if c.id == 3
            c.share_by_user_id(23).should_not be_nil
          else
            c.share_by_user_id(23).should be_nil
          end
        end
      end
    end
  end
end