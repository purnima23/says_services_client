require 'spec_helper'

describe SaysServicesClient::Utils::ClassLevelInheritableAttributes do
  before(:each) do
    reset_class 'Dummy'
  end
  
  it 'should persist their own class instance variable' do
    parent = SaysServicesClient::Models::Base
    parent.attributes.should be_empty
    child = Dummy
    child.attributes.should eq([:name, :email, :id, :address])
  end
end