require 'spec_helper'

describe SaysServicesClient::Models::Base do
  it 'raises error if not defined in attr_accessor or getter methods' do
    dummy = Dummy.new
    expect {dummy.id}.to raise_error(NoMethodError)
    expect {dummy.rank}.to raise_error(NoMethodError)
  end
  
  context '#initialize' do
    it 'sets instance variables' do
      dummy = Dummy.new({name: 'soh', email: 'cherwei@gmail.com'})
      dummy.name.should eq('soh')
      dummy.email.should eq('cherwei@gmail.com')
    end
    
    it 'sets getter methods' do
      dummy = Dummy.new({rank: 'last'})
      dummy.rank.should eq('last')
    end
  end
  
  context '#attributes' do
    it 'returns hash' do
      dummy = Dummy.new
      dummy.attributes.should eq({"name" => nil, "email" => nil})
    end
  end
  
  context '#attributes=' do
    it 'sets instance variables' do
      dummy = Dummy.new
      dummy.attributes = {name: 'test', email: 'email@e.mail'}
      dummy.attributes.should eq({"name" => 'test', "email" => 'email@e.mail'})
    end
  end
  
  context '#dynamic_methods' do
    it 'sets getter methods' do
      dummy = Dummy.new
      dummy.send(:dynamic_methods, {nickname: 'ladyboy'})
      dummy.nickname.should eq('ladyboy')
      expect {dummy.nickname = 'overwrite'}.to raise_error(NoMethodError)
    end
  end
end