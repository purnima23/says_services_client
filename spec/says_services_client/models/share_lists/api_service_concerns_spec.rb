require 'spec_helper'

describe SaysServicesClient::Models::ShareLists::ApiServiceConcerns do  
  context '#find_by_user_id' do
    context 'with block given' do
      it 'returns correct shares' do
        VCR.use_cassette 'Models/ShareLists/ApiServiceConcernsTest/find_by_user_id_23' do
          SaysServicesClient::ShareList.find_by_user_id(23, country: 'my') do |s|
            @list = s
          end
          HYDRA.run
        end
        @list.shares.size.should eq(2)
        @list.shares.first.user_id.should eq(23)
      end      
    end
    
    context 'without block given' do
      it 'returns correct shares' do
        VCR.use_cassette 'Models/ShareLists/ApiServiceConcernsTest/find_by_user_id_23' do
          @list = SaysServicesClient::ShareList.find_by_user_id(23, country: 'my')
        end
        @list.shares.size.should eq(2)
        @list.shares.first.user_id.should eq(23)
      end
    end
  end
end