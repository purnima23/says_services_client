HYDRA = Typhoeus::Hydra.new
SaysServicesClient::Config.hydra = HYDRA
SaysServicesClient::Config.oauth_token = '424b0d825d7966c06ee5b5d20ceb3cfdb7849a8408a91e31de7c093fef0041e8'
SaysServicesClient::Config.endpoint = {
  campaign_url: 'http://localhost:9000/',
  share_url: 'http://localhost:9000/',
  campaign_list_url: 'http://localhost:9000/',
  share_list_url: 'http://localhost:9000/',
  user_list_url: 'http://sociable.dev',
  user_url: 'http://sociable.dev',
  share_stat_url: 'http://localhost:9000/',
  last_job_url: 'http://localhost:9000/',
  cashout_url: 'http://sociable.dev',
  sociable_user_url: 'http://sociable.dev'
}

# enable caching by uncomment
# the option is similar to what dalli accepts
# SaysServicesClient::Cache::Config.hosts = ['localhost:11211']
SaysServicesClient::Cache::Config.option = {
  # namespace: "app_v1",
  compress: true
}
SaysServicesClient::Cache::Config.raise_error = false
Typhoeus::Config.cache = SaysServicesClient::Utils::Cache::DalliClient.new

# SaysServicesClient::Campaign.find(13, country: 'my', cache_ttl: 5)
# SaysServicesClient::Campaign.find(13, country: 'my')
# SaysServicesClient::Campaign.find(13, country: 'my', include: :share_by_user_id, user_id: 1, cache_ttl: 1)

# SaysServicesClient::Campaign.find(13, country: 'my', cache_ttl: 5) {|x| @c = x}
# HYDRA.run