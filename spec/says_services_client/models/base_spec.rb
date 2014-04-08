require 'spec_helper'

describe SaysServicesClient::Models::Base do
  before(:each) do
    reset_class 'Dummy'
  end
  
  describe 'attr_accessor' do
    it 'raises error if not defined' do
      dummy = Dummy.new
      expect {dummy.id}.to raise_error(NoMethodError)
    end
    
    it 'creates setter and getter' do
      dummy = Dummy.new
      dummy.name = 'tester'
      dummy.name.should eq('tester')
    end
    
    it 'adds to class level instance variable' do
      class_attributes = Dummy.attributes
      Dummy.attr_accessor :full_name
      (Dummy.attributes - class_attributes).should eq([:full_name])
    end
  end
  
  describe 'attr_reader' do
    it 'raises error if set' do
      dummy = Dummy.new
      expect {dummy.address = 'error'}.to raise_error(NoMethodError)
    end
    
    it 'creates getter' do
      dummy = Dummy.new({address: 'malaysia'}, as: :admin)
      dummy.address.should eq('malaysia')
    end
    
    it 'adds to class level instance variable' do
      class_attributes = Dummy.attributes
      Dummy.attr_reader :full_name
      (Dummy.attributes - class_attributes).should eq([:full_name])
    end
  end
  
  context '#initialize' do
    it 'sets instance variables' do
      dummy = Dummy.new({name: 'soh'})
      dummy.name.should eq('soh')
    end
    
    it 'skips protected attributes' do
      dummy = Dummy.new({name: 'soh', email: 'cherwei@gmail.com'})
      dummy.email.should be_nil
    end
    
    it 'can set attributes as admin' do
      dummy = Dummy.new({name: 'soh', email: 'cherwei@gmail.com', address: 'malaysia'}, as: :admin)
      dummy.email.should eq('cherwei@gmail.com')
      dummy.address.should eq('malaysia')
    end
  end
  
  context '#attributes' do
    it 'returns hash' do
      Dummy.new.attributes.should eq({"name" => nil, "email" => nil, "address" => nil})
      Dummy.new({"name" => 'n', "email" => 'e', "address" => 'malaysia'}, as: :admin).attributes.should eq({"name" => 'n', "email" => 'e', "address" => 'malaysia'})
    end
  end
  
  context '#attributes=' do
    it 'sets instance variables and skip protected attributes' do
      dummy = Dummy.new
      dummy.attributes = {name: 'test', email: 'email@e.mail'}
      dummy.attributes.should eq({"name" => 'test', "email" => nil, "address" => nil})
    end
  end
  
  context '#assign_attributes' do
    it 'sets instance variables and skip protected attributes' do
      dummy = Dummy.new
      dummy.assign_attributes({name: 'test', email: 'email@e.mail'})
      dummy.attributes.should eq({"name" => 'test', "email" => nil, "address" => nil})
    end
    
    it 'sets instance variables as admin' do
      dummy = Dummy.new
      dummy.assign_attributes({name: 'test', email: 'email@e.mail'}, as: :admin)
      dummy.attributes.should eq({"name" => 'test', "email" => 'email@e.mail', "address" => nil})
    end
  end
end