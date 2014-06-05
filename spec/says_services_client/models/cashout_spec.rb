require 'spec_helper'

describe SaysServicesClient::Cashout, :vcr do

  describe '#all' do
    it 'returns cashouts' do
      cashouts = SaysServicesClient::Cashout.all(country_code: 'my')
      cashouts.count.should eq 1

      cashout = cashouts.first
      cashout.created_at.class.should eq Time
      cashout.updated_at.class.should eq Time
    end

    context 'when include_sum is passed' do
      it 'returns request_amount_sum with last_request' do
        cashouts = SaysServicesClient::Cashout.all(country_code: 'my', include_sum: true)

        SaysServicesClient::Cashout.last_request.request_amount_sum.should_not be_nil
      end
    end
  end
end