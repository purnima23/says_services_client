$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "says_services_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "says_services_client"
  s.version     = SaysServicesClient::VERSION
  s.authors     = ["Soh Cher Wei"]
  s.email       = ["cherwei.soh@says.com"]
  s.homepage    = "https://github.com/says/says_services_client"
  s.summary     = "Says Services API client"
  s.description = "A Services wrapper that provides methods similar to ActiveRecord"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'activemodel', '> 3.2.15'
  s.add_dependency 'activesupport', '> 3.2.15'
  s.add_dependency 'typhoeus', '~> 0.6.8'
  s.add_dependency 'hashie', '~> 2.1.1'
  s.add_dependency 'will_paginate', '~> 3.0'
  s.add_dependency 'activerecord', '> 3.2.15'
  s.add_dependency 'dalli', '> 2.6.2'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "vcr"
  s.add_development_dependency "rspec"
  s.add_development_dependency "shoulda-matchers"
end
