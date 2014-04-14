HYDRA = Typhoeus::Hydra.new
SaysServicesClient::Config.hydra = HYDRA
SaysServicesClient::Config.oauth_token = '6a6b37898f0179405f262a9343258ae6'
SaysServicesClient::Config.endpoint = {
  campaign_url: 'http://localhost:3001/',
  share_url: 'http://localhost:3001/',
  campaign_list_url: 'http://localhost:3001/',
}