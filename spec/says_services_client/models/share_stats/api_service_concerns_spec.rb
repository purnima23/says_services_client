require 'spec_helper'

describe SaysServicesClient::Models::ShareStats::ApiServiceConcerns do  
  context '#find' do
    context 'with block given' do
      it 'returns stat' do
        VCR.use_cassette 'Models/ShareStats/ApiServiceConcernsTest/find_by_user_id_28' do
          SaysServicesClient::ShareStat.find_by_user(28) do |s|
            @stat = s
          end
          HYDRA.run
        end
        @stat.total_rewarded_uv_count.should eq(10)
      end
      
      it 'returns 0 if no users found' do
        VCR.use_cassette 'Models/ShareStats/ApiServiceConcernsTest/find_by_user_id_9283123123' do
          SaysServicesClient::ShareStat.find_by_user(9283123123) do |s|
            @stat = s
          end
          HYDRA.run
        end
        @stat.total_rewarded_uv_count.should eq(0)
      end
    end
    
    context 'without block given' do
      it 'returns stat' do
        VCR.use_cassette 'Models/ShareStats/ApiServiceConcernsTest/find_by_user_id_28' do
          @stat = SaysServicesClient::ShareStat.find_by_user(28)
        end
        @stat.total_rewarded_uv_count.should eq(10)
      end
            
      it 'returns 0 if no users found' do
        VCR.use_cassette 'Models/ShareStats/ApiServiceConcernsTest/find_by_user_id_9283123123' do
          @stat = SaysServicesClient::ShareStat.find_by_user(9283123123)
        end
        @stat.total_rewarded_uv_count.should eq(0)
      end
    end
  end
end