require 'spec_helper'

describe SaysServicesClient::Utils::OperationConcerns do
  describe 'ClassMethods' do
    before(:each) do
      reset_class 'Dummy'
    end
    
    describe '#create' do
      it 'should call #new with attributes' do
        Dummy.should_receive(:new).with({name: 'name'}).and_return(double("dummy", save: true))
        Dummy.create(name: 'name')
      end
      
      it 'should call #save' do
        dummy = double("dummy")
        Dummy.stub(:new).and_return(dummy)
        dummy.should_receive(:save)
        Dummy.create(name: 'name')
      end
      
      it 'should return object' do
        mock = double("dummy", save: true)
        Dummy.stub(:new).with({name: 'name'}).and_return(mock)
        Dummy.create(name: 'name').should eq(mock)
      end
    end
  end
  
  describe '#save' do
    it 'should call #create_or_update' do
      dummy = Dummy.new
      dummy.should_receive(:create_or_update)
      dummy.save
    end
  end
  
  describe 'private' do
    describe '#create_operation_service' do
      it 'should raise error' do
        expect do
          Dummy.new.send(:create_operation_service)
        end.to raise_error
      end
    end
  
    describe '#create_or_update' do
      before(:each) do
        @dummy = Dummy.new
      end
      
      it 'calls create for new record' do
        @dummy.stub(:new_record?).and_return(true)
        @dummy.should_receive(:create)
        @dummy.send(:create_or_update)
      end
      
      it 'calls update for persisted record' do
        @dummy.stub(:new_record?).and_return(true)
        @dummy.should_receive(:create)
        @dummy.send(:create_or_update)
      end
      
      it 'returns true if success' do
        @dummy.stub(:create).and_return(true)
        @dummy.send(:create_or_update).should be_true
      end
      
      it 'returns false if fail' do
        @dummy.stub(:create).and_return(false)
        @dummy.send(:create_or_update).should be_false
      end
    end
    
    describe '#create' do
      before(:each) do
        @dummy = Dummy.new
      end
      
      it 'calls #valid?' do
        @dummy.should_receive(:valid?)
        @dummy.send(:create)
      end
      
      it 'returns false if valid? is false' do
        @dummy.stub(:valid?).and_return(false)
        @dummy.send(:create).should eq(false)
      end
      
      it 'calls #create_operation_service if valid? is true' do
        @dummy.stub(:valid?).and_return(true)
        @dummy.should_receive(:create_operation_service)
        @dummy.send(:create)
      end
    end
  end
end