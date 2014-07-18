require 'spec_helper'

describe SaysServicesClient::TrafficReferrer, :vcr do
  describe '#all' do
    it 'returns traffic referrers' do
      tr = SaysServicesClient::TrafficReferrer.all(country: 'my')
      tr.count.should eq 1
      tr.first.id.should eq 1
      tr.total_entries.should eq 1
    end

    context 'when more options are passed' do
      it 'should escalate to superclass with correct options' do
        SaysServicesClient::TrafficReferrer.should_receive(:establish_connection).with("/my/api/admin/v1/traffic_referrers", params: {country: 'my', utm_source: 'adsite.com', extra_field: 'yes'}, service_name: :cashout_url).and_call_original
        tr = SaysServicesClient::TrafficReferrer.all(country: 'my', utm_source: 'adsite.com', extra_field: 'yes')
      end
    end

    context 'when paginating' do
      it 'returns traffic referrers by page' do
        tr = SaysServicesClient::TrafficReferrer.all(country: 'my', page: 2)
        tr.count.should eq 0
      end
    end
  end
end
