require 'spec_helper'

describe SaysServicesClient::History, :vcr do
  describe 'validations' do
    it {should validate_presence_of(:action_taken)}
    it {should validate_presence_of(:user_id)}
    it {should validate_presence_of(:remarks)}
  end
  
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
  
  describe '#save' do
    it 'returns true if record created' do
      share = SaysServicesClient::History.new(user_id: 3, action_taken: 'Sent warning email', remarks: 'testing', country_code: 'my')
      share.save.should be_true
      share.new_record?.should be_false
      share.action_taken.should eq('Sent warning email')
      share.user_id.should eq(3)
      share.id.should_not be_blank
    end        
  end
end