require 'spec_helper'

describe SaysServicesClient::Transaction, :vcr do

  describe '#all' do
    it 'returns transactions' do
      transactions = SaysServicesClient::Transaction.all(country_code: 'my', user_id: 1)
      transactions.count.should eq 1

      cashout = transactions.first
      cashout.created_at.class.should eq Time
    end

    context 'when paginating' do
      it 'returns paginated collection' do
        transactions = SaysServicesClient::Transaction.all(page: 1, per_page: 2, country_code: 'my', user_id: 1)

        transactions.count.should eq 2
        transactions.current_page.should eq 1
        transactions.total_entries.should eq 5
      end
    end
  end
end