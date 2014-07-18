require 'spec_helper'

describe SaysServicesClient::Models::Base do
  before(:each) do
    reset_class 'Dummy'
  end
  
  describe '#new_record?' do
    it 'should return false base on #persisted?' do
      dummy = Dummy.new
      dummy.should_receive(:persisted?).and_return(true)
      dummy.new_record?.should be false
    end
    
    it 'should return true base on #persisted?' do
      dummy = Dummy.new
      dummy.should_receive(:persisted?).and_return(false)
      dummy.new_record?.should be true
    end
  end
  
  describe '#persisted?' do
    it 'should return false unless id present' do
      dummy = Dummy.new
      dummy.should_receive(:id).and_return(nil)
      dummy.persisted?.should be false
    end
    
    it 'should return true if id present' do
      dummy = Dummy.new
      dummy.should_receive(:id).and_return(1)
      dummy.persisted?.should be true
    end
  end
  
  describe '#find' do
    it 'is implemented' do
      pending("should be tested individually in child")
    end
  end
  
  describe '#save' do
    it 'should call #create_or_update' do
      dummy = Dummy.new(name: 'abc')
      dummy.should_receive(:create_or_update).with({})
      dummy.save
    end
        
    it 'is implemented' do
      pending("should be tested individually in child")
    end
  end
  
  describe '#create_or_update' do
    before(:each) do
      @dummy = Dummy.new
    end
    
    it 'calls create for new record' do
      @dummy.stub(:new_record?).and_return(true)
      @dummy.should_receive(:create).with(method: :post)
      @dummy.send(:create_or_update)
    end
    
    it 'calls update for persisted record' do
      @dummy.stub(:new_record?).and_return(false)
      @dummy.should_receive(:update).with(method: :put)
      @dummy.send(:create_or_update)
    end
    
    it 'returns true if success' do
      @dummy.stub(:create).and_return(true)
      @dummy.send(:create_or_update).should be true
    end
    
    it 'returns false if fail' do
      @dummy.stub(:create).and_return(false)
      @dummy.send(:create_or_update).should be false
    end
  end
  
  describe 'instance private method #create' do
    before(:each) do
      @dummy = Dummy.new
    end
    
    it 'returns false if valid? is false' do
      @dummy.should_not_receive(:create!)
      @dummy.stub(:valid?).and_return(false)
      @dummy.send(:create).should eq(false)
    end
    
    it 'calls #create! if valid? is true' do
      @dummy.should_receive(:create!)
      @dummy.stub(:valid?).and_return(true)
      @dummy.send(:create)
    end
  end
  
  describe '#update' do
    before(:each) do
      @dummy = Dummy.new
      @dummy.stub(:new_record?).and_return(false)
    end
    
    it 'returns false if valid? is false' do
      @dummy.should_not_receive(:update!)
      @dummy.stub(:valid?).and_return(false)
      @dummy.send(:update).should eq(false)
    end
    
    it 'calls #update! if valid? is true' do
      @dummy.should_receive(:update!)
      @dummy.stub(:valid?).and_return(true)
      @dummy.send(:update)
    end
  end
  
  describe '#post!' do
    it 'should be success' do
      # TODO
    end
    
    it 'should able to capture and raise 500' do
      # TODO
    end
    
    it 'should able to capture 404 and set to base as errors' do
      # TODO
    end
  end
  
  describe 'class method #create' do
    it 'should be success' do
      # TODO
    end
    
    it 'should return object with base errors if not success' do
      # TODO
    end
  end
end