require 'spec_helper'

describe SaysServicesClient::User do
  describe '#all', :vcr do
    it 'returns users' do
      users = SaysServicesClient::User.all(country: 'my')
      users.count.should == 2
    end

    context 'when filters are passed' do
      it 'returns users based on filters' do
        users = SaysServicesClient::User.all(country: 'my', keyword: 'nguyen')
        users.count.should == 1
      end
    end
  end
end