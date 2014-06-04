require 'spec_helper'

describe SaysServicesClient::User, :vcr do
  describe '#all' do
    it 'returns users' do
      users = SaysServicesClient::User.all(country: 'malaysia')
      users.count.should == 5

      user = users.first
      user.id.should eq 1
      user.login.should eq 'nguyen'
      user.name.should eq 'Nguyen'
      user.email.should eq 'nguyen@localhost.com'
      user.gender.should eq 'Male'
      user.status.should eq 'activated'
      user.activated_at.should_not be_nil
    end

    context 'when filters are passed' do
      it 'returns users based on filters' do
        users = SaysServicesClient::User.all(keyword: 'nguyen')
        users.count.should == 3
      end
    end
  end

  describe "#find" do
    it 'returns user' do
      user = SaysServicesClient::User.find(1)
      
      user.login.should eq 'nguyen'
      user.avatar_url.should eq 'http://says-connect-development.s3-website-ap-southeast-1.amazonaws.com/avatars/small_thumb.jpg'
      user.bank_account.should eq '123456786544'
      user.bank_name.should eq 'MAYBANK BERHAD'
      user.city.should eq 'Johor'
      user.country.should eq 'malaysia'
      user.dob.should eq '1999-03-03'
      user.email.should eq 'nguyen@localhost.com'
      user.gender.should eq 'Male'
      user.ident_no.should eq '123456789012'
      user.name.should eq 'Nguyen'
      user.phone_number.should eq '12345678'
      user.race.should eq 'Chinese'
      user.status.should eq 'activated'
      user.created_at.should_not eq be_nil
      user.updated_at.should_not eq be_nil
    end
  end
end
