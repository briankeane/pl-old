require 'bcrypt'

module PL
  class User < Entity
    attr_accessor :twitter, :email, :id, :twitter_uid
    attr_reader :password_digest

    def initialize(attrs)
      if attrs[:password]
        @password_digest = BCrypt::Password.create(attrs.delete(:password))
      end

      super(attrs)
    end

    def password_correct?(password)
      @password_digest == password
    end

    def password_digest=(password_digest)
      @password_digest = BCrypt::Password.new(password_digest)
    end
  end
end
