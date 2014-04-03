require 'spec_helper'

describe SaysServicesClient::Models::Campaign do
  context '#find' do
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
    end
    
    context 'without block given' do
      it 'returns correct campaign' do
        VCR.use_cassette 'CampaignTest_#find_11' do
          @campaign = SaysServicesClient::Campaign.find(11)
        end
        @campaign.id.should eq(11)
      end
    end
  end
  
  context '#all' do
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
    end
  end
end