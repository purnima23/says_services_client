require 'spec_helper'

describe SaysServicesClient::Campaign, :vcr do
  describe '#triggers=' do
    it 'wraps trigger as class' do
      campaign = SaysServicesClient::Campaign.new
      campaign.triggers = [{id: 1, message: 'wrapper'}]
      campaign.triggers.is_a?(Array).should be_true
      campaign.triggers.first.is_a?(SaysServicesClient::Trigger).should be_true
      campaign.triggers.first.id.should eq(1)
    end
  end
  
  context '#find' do
    context 'include_share_by_user_id' do
      it 'should raise error if include share by user id without user_id' do
        expect do
          @campaign = SaysServicesClient::Campaign.find(12, country: 'my', include: :share_by_user_id)
        end.to raise_error
      end      
    end
    
    it 'should success' do
      SaysServicesClient::Campaign.find(12, country: 'my') do |c|
        @campaign = c
      end
      HYDRA.run
      @campaign.id.should eq(12)
    end
    
    it 'can include share by user id' do
      @campaign = SaysServicesClient::Campaign.find(12, country: 'my', include: :share_by_user_id, user_id: 1)
      @campaign.id.should eq(12)
      @campaign.shares.should_not be_nil
      @campaign.share_by_user_id(1).should_not be_nil
      @campaign.share_by_user_id(1).is_a?(SaysServicesClient::Share).should be_true
    end
  end
    
  context '#all' do
    context 'include_share_by_user_id' do
      it 'should not run #include_request_share_by_user_id if campaigns is empty' do
        SaysServicesClient::Campaign.should_not_receive(:include_request_share_by_user_id)
        @campaigns = SaysServicesClient::Campaign.all(country: 'in', include: :share_by_user_id, user_id: 1)
        @campaigns.campaigns.size.should eq(0)
      end      
      
      it 'should raise error if include share by user id without user_id' do
        expect do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id)
        end.to raise_error
      end
      
      it 'should raise rror if include share by user id with blank' do
        expect do
          @campaigns = SaysServicesClient::Campaign.all(country: 'my', include: :share_by_user_id, user_id: nil)
        end.to raise_error
      end
      
      it 'should success' do
        target = {
          campaigns_offset: "", 
          target_age: 14.46, 
          target_gender: "Male", 
          target_race: "Chinese", 
          target_city: "Selangor", 
          user_id: 3, 
          tag: "", 
          include: :share_by_user_id,
          user_id: 3,
          country: "my"
        }
        
        SaysServicesClient::Campaign.all(target) do |c|
          @campaigns = c
        end
        HYDRA.run

        @campaigns.campaigns.size.should eq(3)
        @campaigns.campaigns.each do |c|
          c.shares.should_not be_nil
          # campaign id: 3, and 12 has a share of user_id: 3
          if c.id == 2
            c.share_by_user_id(3).should be_nil
          else
            c.share_by_user_id(3).should_not be_nil
          end
        end
      end
    end
    
    it 'requires country' do
      expect do
        @campaigns = SaysServicesClient::Campaign.all
      end.to raise_error
    end
    
    context 'with ids' do
      it 'should returns campaigns in ids' do
        @campaigns = SaysServicesClient::Campaign.all(ids: [3, 12], country: 'my')
        @campaigns.campaigns.size.should eq(2)
        @campaigns.campaigns.first.id.should eq(3)
        @campaigns.campaigns.last.id.should eq(12)
      end
    end
  end
  
  context '#recommendations_for_user' do
    it 'should be success' do
      SaysServicesClient::Campaign.recommendations_for_user(28, {country: 'my'}) do |c|
        @campaigns = c
      end
      HYDRA.run
      @campaigns.size.should eq(3)
      @campaigns.map(&:id).should eq([3,2,13])
    end    
  end
  
  context '#all_path' do
    it 'appends ids to URL if present in hash as integer' do
      path = SaysServicesClient::Campaign.send(:all_path, ids: 2, country: 'my')
      path.should eq("/my/api/v2/campaigns?ids=2")
    end
    
    it 'appends ids to URL if present in hash as array' do
      path = SaysServicesClient::Campaign.send(:all_path, ids: [1,2,3], country: 'my')
      path.should eq("/my/api/v2/campaigns?ids=1,2,3")
    end
    
    it 'should not append campaign_ids to URL if not present' do
      path = SaysServicesClient::Campaign.send(:all_path, country: 'my')
      path.should eq("/my/api/v2/campaigns")
    end
  end
end