require 'spec_helper'

describe SaysServicesClient::ShareStat, :vcr do
  context '#find_by_user_id' do
    it 'should success' do
        SaysServicesClient::ShareStat.find_by_user_id(28, country: 'my') do |s|
          @stat = s
        end
        HYDRA.run
      @stat.total_rewarded_uv_count.should eq(10)
    end
      
    it 'returns 0 if no users found' do
      SaysServicesClient::ShareStat.find_by_user_id(9283123123, country: 'my') do |s|
        @stat = s
      end
      HYDRA.run
      @stat.total_rewarded_uv_count.should eq(0)
    end
    
    context 'without block given' do
      it 'should success' do
        @stat = SaysServicesClient::ShareStat.find_by_user_id(28, country: 'my')
        @stat.total_rewarded_uv_count.should eq(10)
      end
            
      it 'returns 0 if no users found' do
        @stat = SaysServicesClient::ShareStat.find_by_user_id(9283123123, country: 'my')
        @stat.total_rewarded_uv_count.should eq(0)
      end
    end
  end
end