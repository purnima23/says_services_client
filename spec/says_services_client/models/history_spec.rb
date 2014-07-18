require 'spec_helper'

describe SaysServicesClient::History, :vcr do
  describe '#all' do
    it 'returns histories' do
      histories = SaysServicesClient::History.all(4, country_code: 'my')
      histories.count.should eq 6

      history = histories.first
      history.created_at.class.should eq Time
    end

    context 'when paginating' do
      it 'returns paginated collection' do
        histories = SaysServicesClient::History.all(4, page: 1, per_page: 2, country_code: 'my')

        histories.count.should eq 2
        histories.current_page.should eq 1
        histories.total_entries.should eq 6
      end
    end
  end
end