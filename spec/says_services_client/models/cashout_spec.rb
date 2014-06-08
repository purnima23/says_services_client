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

  describe '#update' do
    it 'updates cashout' do
      cashout = SaysServicesClient::Cashout.update(1, country_code: 'my', update_action: 'verify')

      cashout.state.should eq 'verified'
    end

    context 'when there is error' do
      it 'returns error' do
        cashout = SaysServicesClient::Cashout.update(1, country_code: 'my', update_action: 'verify')

        cashout.errors.first.should eq "Your account does not reach cash-out amount."
      end
    end
  end

  describe '#update_all' do
    it 'updates all cashouts' do
      response = SaysServicesClient::Cashout.update_all(status: 'pending', country_code: 'my', update_action: 'verify')
      response.errors.should be_empty

      cashouts = SaysServicesClient::Cashout.all(country_code: 'my')
      cashouts.first.state.should eq 'verified'
      cashouts.last.state.should eq 'verified'
    end

    context 'when there is error' do
      it 'updates all cashouts' do
        response = SaysServicesClient::Cashout.update_all(status: 'pending', country_code: 'my', update_action: 'verify')
        response.errors.first.should eq "Your account does not reach cash-out amount."
      end
    end
  end
end