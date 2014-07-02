HYDRA = Typhoeus::Hydra.new
SaysServicesClient::Config.hydra = HYDRA
SaysServicesClient::Config.oauth_token = '424b0d825d7966c06ee5b5d20ceb3cfdb7849a8408a91e31de7c093fef0041e8'
SaysServicesClient::Config.endpoint = {
  campaign_url: 'http://localhost:9000',
  share_url: 'http://localhost:9000',
  campaign_list_url: 'http://localhost:9000',
  share_list_url: 'http://localhost:9000',
  user_url: 'http://says-connect.dev',
  sociable_user_url: 'http://sociable2.dev',
  share_stat_url: 'http://localhost:9000',
  cashout_url: 'http://sociable2.dev',
  last_job_url: 'http://localhost:9000',
  transaction_url: 'http://sociable2.dev'
}