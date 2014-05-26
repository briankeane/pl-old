require 'omniauth-twitter'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '3ygdb9pG0xzJDM4EOU7X40Otf', 'Qc3cEututovQKtPIVF213hNU2y52YZCjy8hcOBVPvJRovW5O2d'
end
