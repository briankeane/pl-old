require 'bcrypt'

module PL
  class User < Entity
    attr_accessor :twitter, :email, :id, :password_digest, :twitter_uid

    def initialize(attrs)
      if attrs[:password]
        @password_digest = BCrypt::Password.create(attrs.delete(:password))
      end

      super(attrs)
    end

    def password_correct?(password)
      @password_digest == password
    end
  end
end
