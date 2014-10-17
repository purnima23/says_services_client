require 'spec_helper'

describe SaysServicesClient::Job, :vcr do

  describe '#create' do
    it 'creates job' do
      job = SaysServicesClient::Job.create('vn', namespace: "cashout",
                                                  job_action: "update_all",
                                               update_action: "complete",
                                                      status: "verified",
                                                        type: "CashCashout")

      expect(job.id).to_not be_nil
    end
  end

  describe '#find' do
    before do
      @current_job = SaysServicesClient::Job.create('vn', namespace: "cashout",
                                                  job_action: "update_all",
                                               update_action: "complete",
                                                      status: "verified",
                                                        type: "CashCashout")
    end

    it 'finds job' do
      job = SaysServicesClient::Job.find('vn', @current_job.id)

      expect(job.status).to eq("complete")
    end
  end
end
