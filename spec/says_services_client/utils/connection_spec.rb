require 'spec_helper'

describe SaysServicesClient::Utils::Connection do
  before(:each) do
    SaysServicesClient::Config.stub(:endpoint).and_return({connection_url: 'http://localhost:9000'})
  end
  
  context '#establish_connection' do
    it 'returns instance of Typhoeus' do
      SaysServicesClient::Utils::Connection.send(:establish_connection, 'path').is_a?(Typhoeus::Request).should be_true
    end
    
    it 'merge options to Typhoeus as params' do
      conn = SaysServicesClient::Utils::Connection.send(:establish_connection, 'path', params: {country: 'my', target_age: 8})
      conn.options[:params][:country].should eq('my')
      conn.options[:params][:target_age].should eq(8)
    end
  end
  
  it "embeds token to Typhoeus's params" do
    conn = SaysServicesClient::Utils::Connection.send(:establish_connection, 'path')
    conn.options[:params][:token].should_not nil
  end
  
  context '#service_name' do
    it 'returns connection_url' do
      SaysServicesClient::Utils::Connection.send(:service_name).should eq(:connection_url)
    end
    
    it 'returns dummy_url' do
      Dummy.send(:service_name).should eq(:dummy_url)
    end
  end
  
  context '#endpoint' do
    it 'returns correct value' do
      SaysServicesClient::Utils::Connection.send(:endpoint).should eq('http://localhost:9000')
    end
  end
end