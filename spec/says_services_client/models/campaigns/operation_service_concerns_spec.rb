require 'spec_helper'

describe SaysServicesClient::Models::Campaigns::OperationServiceConcerns do
  describe 'private' do
    describe '#update' do
      it 'returns true if record created' do
        VCR.use_cassette 'Models/Campaigns/OperationServiceConcernsTest/success_update' do
          campaign = SaysServicesClient::Campaign.find 13
          campaign.send(:update).should be_true
        end
      end
      
      it 'returns false if record not saved' do
        VCR.use_cassette 'Models/Campaigns/OperationServiceConcernsTest/fail_update' do
          campaign = SaysServicesClient::Campaign.find 13
          campaign.title = ''
          campaign.send(:update).should be_false
          campaign.errors["title"].should_not be_empty
        end
      end
    end
  end
end