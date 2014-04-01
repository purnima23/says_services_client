class Dummy < SaysServicesClient::Models::Base
  ATTRIBUTES = [:name, :email]
  attr_accessor *ATTRIBUTES
end