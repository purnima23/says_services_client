require 'spec_helper'

describe SaysServicesClient::Bank, :vcr do
  describe '#all' do
    it 'returns banks' do
      banks = SaysServicesClient::Bank.all('my')

      expect(banks.first.name).to_not be_nil
    end

  end
end
