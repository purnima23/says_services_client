module SaysServicesClient
  class Config
    class << self
      attr_accessor :host, :hydra, :oauth_token, :endpoint
    end
  end
end