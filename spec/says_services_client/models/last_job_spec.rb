require 'spec_helper'

describe SaysServicesClient::LastJob, :vcr do

  describe '#find' do
    it 'should return last job' do
      cashout = SaysServicesClient::LastJob.find('clicks_filter', country: 'my')
      cashout.job_name.should eq 'clicks_filter'
      cashout.last_run.should_not be_empty
    end
  end
end