require 'spec_helper'

describe SaysServicesClient::User, :vcr do
  describe '#all' do
    it 'returns users' do
      users = SaysServicesClient::User.all(country: 'malaysia')
      users.count.should eq 5

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
        
        users.count.should eq 3
      end
    end

    context 'when paginating' do
      it 'returns users by page' do
        users = SaysServicesClient::User.all(page: 1,
                                             per_page: 2)

        users.count.should eq 2
        users.current_page.should eq 1
        users.total_entries.should eq 6
      end
    end

    context 'when source is sociable' do
      it 'returns users from sociable' do
        users = SaysServicesClient::User.all(country: 'my', source: 'sociable')

        users.count.should eq 2
        user =  users.first
        user.id.should eq 1
        user.email.should eq "nguyen@localhost.com"
        user.display_name.should eq "Nguyen"
        user.wallet.should eq "RM9,992.00"
        user.country.should eq "malaysia"
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
      user.country_name.should eq 'malaysia'
      user.dob.should eq Time.parse('1999-03-03')
      user.email.should eq 'nguyen@localhost.com'
      user.gender.should eq 'Male'
      user.ident_no.should eq '123456789012'
      user.name.should eq 'Nguyen'
      user.phone_number.should eq '12345678'
      user.race.should eq 'Chinese'
      user.status.should eq 'activated'
      user.created_at.should_not be_nil
      user.updated_at.should_not be_nil
    end

    context 'when sociable is included' do
      it 'merges user info from sociable' do
        user = nil
        SaysServicesClient::User.find(1, include: :sociable, country_code: 'my') do |result|
          user = result
        end
        HYDRA.run

        user.login.should eq 'nguyen'
        user.avatar_url.should eq 'http://says-connect-development.s3-website-ap-southeast-1.amazonaws.com/avatars/small_thumb.jpg'
        user.bank_account.should eq '123456786544'
        user.bank_name.should eq 'MAYBANK BERHAD'
        user.city.should eq 'Johor'
        user.country_name.should eq 'malaysia'
        user.dob.should eq Time.parse('1999-03-03')
        user.email.should eq 'nguyen@localhost.com'
        user.gender.should eq 'Male'
        user.ident_no.should eq '123456789012'
        user.name.should eq 'Nguyen'
        user.phone_number.should eq '12345678'
        user.race.should eq 'Chinese'
        user.status.should eq 'activated'
        user.created_at.should_not be_nil
        user.updated_at.should_not be_nil
        user.invite_link.should_not be_nil
        user.wallet.should eq "RM0.00"
        user.contribution_point.should eq 0
        user.warn.should eq false
        user.banned_from_campaign.should eq false
      end
    end
  end
end
