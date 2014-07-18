require 'spec_helper'

describe SaysServicesClient::Utils::Connection do
  before(:each) do
    SaysServicesClient::Config.stub(:endpoint).and_return({connection_url: 'http://localhost:9000'})
    @connection = reset_class('Connection')
  end
  
  context '#establish_connection' do
    it 'returns instance of Typhoeus' do
      @connection.send(:establish_connection, 'path').is_a?(Typhoeus::Request).should be_true
    end
    
    it 'merge options to Typhoeus as params' do
      conn = @connection.send(:establish_connection, 'path', params: {country: 'my', target_age: 8})
      conn.options[:params][:country].should eq('my')
      conn.options[:params][:target_age].should eq(8)
    end
  end
  
  it "embeds token to Typhoeus's params" do
    conn = @connection.send(:establish_connection, 'path')
    conn.options[:params][:token].should_not nil
  end
  
  context '#service_name' do
    it 'returns connection_url' do
      @connection.send(:service_name).should eq(:connection_url)
    end    
  end
  
  context '#endpoint' do
    it 'returns correct value' do
      @connection.send(:endpoint).should eq('http://localhost:9000')
    end
  end
end