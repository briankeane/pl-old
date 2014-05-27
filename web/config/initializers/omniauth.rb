require 'omniauth-twitter'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'yLQBPT7MfzKmse2WbYfuZIGLn', '4aYM80028GfWOaqGBIRItT4DGjAIOzQ82Iezsyo7tdZILM9uRb'
end
