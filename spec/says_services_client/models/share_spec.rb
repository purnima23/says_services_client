require 'spec_helper'

describe SaysServicesClient::Share, :vcr do
  describe 'validation' do
    before(:each) do
      @share = SaysServicesClient::Share.new
    end
    
    it 'should require user_id on create' do
      @share.valid?.should be_false
      @share.errors.messages[:user_id].should_not be_blank
    end
    
    it 'should require campaign_id on create' do
      @share.valid?.should be_false
      @share.errors.messages[:campaign_id].should_not be_blank
    end
    
    it 'should require username on create' do
      @share.valid?.should be_false
      @share.errors.messages[:username].should_not be_blank
    end
    
    it 'should require message on create' do
      @share.valid?.should be_false
      @share.errors.messages[:message].should_not be_blank
    end
  end
  
  context '#find' do
    context 'with block given' do
      it 'returns correct share with id' do
        SaysServicesClient::Share.find(121, country: 'my') do |s|
          @share = s
        end
        HYDRA.run
        @share.id.should eq(121)
      end
      
      it 'returns empty if no shares found' do
        SaysServicesClient::Share.find(9283123123, country: 'my') do |s|
          @share = s
        end
        HYDRA.run
        @share.should be_nil
      end
    end
    
    context 'without block given' do
      it 'returns correct share id' do
        @share = SaysServicesClient::Share.find(121, country: 'my')
        @share.id.should eq(121)
      end
            
      it 'returns empty if no shares found' do
        @share = SaysServicesClient::Share.find(9283123123, country: 'my')
        @share.should be_nil
      end
    end
  end
  
  context '#find_by_user_id' do
    context 'with block given' do
      it 'returns correct shares' do
        SaysServicesClient::Share.find_by_user_id(3, country: 'my') do |s|
          @shares = s
        end
        HYDRA.run
        @shares.shares.size.should eq(2)
        @shares.shares.first.user_id.should eq(3)
      end      
    end    
    
    it 'returns correct share with campaign_ids' do
      SaysServicesClient::Share.find_by_user_id(3, campaign_ids: 12, country: 'my') do |s|
        @shares = s
      end
      HYDRA.run
      @shares.shares.size.should eq(1)
      @shares.shares.first.user_id.should eq(3)
      @shares.shares.first.campaign_id.should eq(12)
    end
  end
  
  context '#find_by_user_id_path' do
    it 'appends campaign_ids to URL if present in hash as integer' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: 2, country: 'my')
      path.should eq("/my/api/v2/shares/users/23?campaign_ids=2")
    end
    
    it 'appends campaign_ids to URL if present in hash as array' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, campaign_ids: [1,2,3], country: 'my')
      path.should eq("/my/api/v2/shares/users/23?campaign_ids=1,2,3")
    end
    
    it 'should not append campaign_ids to URL if not present' do
      path = SaysServicesClient::Share.send(:find_by_user_id_path, 23, country: 'my')
      path.should eq("/my/api/v2/shares/users/23")
    end
  end
  
  describe '#create!' do
    it 'returns true if record created' do
      share = SaysServicesClient::Share.new(user_id: 28, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
      share.send(:create!, method: :post).should be_true
      share.new_record?.should be_false
    end
    
    # TODO
    # it 'returns false if record not created' do
    #   share = SaysServicesClient::Share.new(user_id: 71, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
    #   share.send(:create!, method: :post).should be_false
    #   share.new_record?.should be_true
    # end
    
    it 'assigns attributes for returned record' do
      share = SaysServicesClient::Share.new(user_id: 29, campaign_id: 12, username: 'newbie', message: 'Are you nutz?', country_code: 'my')
      share.send(:create!, method: :post).should be_true
      share.new_record?.should be_false
      share.share_url.should eq('http://newbie.invisible.dev/my-126')
      share.username.should eq('newbie')
      share.message.should eq("Are you nutz?")
      share.campaign_id.should eq(12)
      share.user_id.should eq(29)
      share.id.should eq(126)
    end
  end
end