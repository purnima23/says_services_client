require 'spec_helper'

describe SaysServicesClient::Models::Shares::OperationServiceConcerns do
  describe 'private' do
    describe '#create_operation_service' do
      it 'returns true if record created' do
        VCR.use_cassette 'Models/Shares/OperationServiceConcernsTest/success_create' do
          share = SaysServicesClient::Share.new(user_id: 28, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
          share.send(:create_operation_service).should be_true
          share.new_record?.should be_false
        end
      end
      
      it 'returns false if record not created' do
        VCR.use_cassette 'Models/Shares/OperationServiceConcernsTest/fail_create' do
          share = SaysServicesClient::Share.new(user_id: 23, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
          share.send(:create_operation_service).should be_false
          share.new_record?.should be_true
        end
      end
      
      it 'assigns attributes for returned record' do
        VCR.use_cassette 'Models/Shares/OperationServiceConcernsTest/success_create' do
          share = SaysServicesClient::Share.new(user_id: 28, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
          share.send(:create_operation_service).should be_true
          share.new_record?.should be_false
          share.share_url.should eq('http://bit.ly/1m5TFgY')
          share.username.should eq('newbie')
          share.message.should eq("Are you nutz?")
          share.campaign_id.should eq(12)
          share.user_id.should eq(28)
          share.created_at.should eq("2014-04-15T16:13:49+08:00")
          share.id.should eq(41)
        end
      end
    end
  end
end