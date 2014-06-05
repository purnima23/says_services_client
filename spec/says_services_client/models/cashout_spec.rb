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
  end
end