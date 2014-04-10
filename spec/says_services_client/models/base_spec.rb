require 'spec_helper'

describe SaysServicesClient::Models::Base do
  before(:each) do
    reset_class 'Dummy'
  end
  
  describe 'attr_accessor' do
    it 'creates setter and getter' do
      Dummy.new.respond_to?("name").should be_true
      Dummy.new.respond_to?("name=").should be_true
    end
    
    it 'adds to class level instance variable' do
      class_attributes = Dummy.attributes
      Dummy.attr_accessor :full_name
      (Dummy.attributes - class_attributes).should eq([:full_name])
    end
  end
  
  describe 'attr_reader' do
    it 'should not create setter method' do
      Dummy.new.respond_to?("address=").should be_false
    end
    
    it 'creates getter' do
      Dummy.new.respond_to?("name").should be_true
    end
    
    it 'adds to class level instance variable' do
      class_attributes = Dummy.attributes
      Dummy.attr_reader :full_name
      (Dummy.attributes - class_attributes).should eq([:full_name])
    end
  end
  
  context '#initialize' do
    it 'sets @new_record as true' do
      Dummy.new.instance_variable_get("@new_record").should be_true
    end
    
    it 'sets instance variables' do
      dummy = Dummy.new({name: 'soh'})
      dummy.name.should eq('soh')
    end
    
    it 'skips protected attributes' do
      dummy = Dummy.new({name: 'soh', email: 'cherwei@gmail.com'})
      dummy.email.should be_nil
    end    
  end
  
  context '#instantiate' do
    it 'sets @new_record as false' do
      Dummy.instantiate.instance_variable_get("@new_record").should be_false
    end
    
    it 'sets attribute readers' do
      dummy = Dummy.instantiate({address: 'puchong'})
      dummy.address.should eq('puchong')
    end
    
    it 'sets attributes' do
      dummy = Dummy.instantiate({name: 'soh'})
      dummy.name.should eq('soh')
    end
    
    it 'sets protected attributes' do
      dummy = Dummy.instantiate({name: 'soh', email: 'cherwei@gmail.com'})
      dummy.email.should eq("cherwei@gmail.com")
    end
  end
  
  context '#new_record?' do
    it 'returns true if @new_record is true' do
      dummy = Dummy.new
      dummy.instance_variable_set(:@new_record, true)
      dummy.new_record?.should be_true
    end
    
    it 'returns false if @new_record is false' do
      dummy = Dummy.new
      dummy.instance_variable_set(:@new_record, false)
      dummy.new_record?.should be_false
    end
  end
  
  context '#valid?' do      
    it 'should validate correctly #1' do
      new = Dummy.new(name: "name")
      new.email = 'email'
      new.valid?.should be_true
    end
      
    it 'should validate correctly #2' do
      new = Dummy.instantiate(name: "name", address: "address")
      new.valid?.should be_true
    end
    
    it 'should validate all context correctly' do
      new = Dummy.new
      new.valid?.should be_false
      new.errors.messages[:name].should_not be_blank
    end
      
    it 'should validate all context correctly' do
      new = Dummy.instantiate
      new.valid?.should be_false
      new.errors.messages[:name].should_not be_blank
    end
    
    it 'should validate on create correctly' do
      new = Dummy.new
      new.valid?.should be_false
      new.errors.messages[:email].should_not be_blank
      new.errors.messages[:address].should be_blank
    end
    
    it 'should validate on update correctly' do
      new = Dummy.instantiate
      new.valid?.should be_false
      new.errors.messages[:email].should be_blank
      new.errors.messages[:address].should_not be_blank
    end
  end
  
  context '#attributes' do
    it 'returns hash' do
      Dummy.new.attributes.should eq({"name" => nil, "email" => nil, "address" => nil})
      Dummy.any_instance.stub(:name).and_return("name")
      Dummy.any_instance.stub(:email).and_return("email")
      Dummy.any_instance.stub(:address).and_return("malaysia")
      Dummy.new.attributes.should eq({"name" => 'name', "email" => 'email', "address" => 'malaysia'})
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
  
  context '#assign_reader_attrs' do
    it 'sets variable unless respond to setter' do
      dummy = Dummy.new
      dummy.send(:assign_reader_attrs, {name: 'name', address: 'address'})
      dummy.instance_variable_get(:@name).should be_nil
      dummy.instance_variable_get(:@address).should eq("address")
    end
    
    it 'delete from hash after set' do
      dummy = Dummy.new
      hash = {name: 'name', address: 'address'}
      hash.should_receive(:delete).with(:address)
      hash.should_not_receive(:delete)
      dummy.send(:assign_reader_attrs, hash)
    end
  end
end