require 'bcrypt'

module PL
  class User < Entity
    attr_accessor :twitter, :email, :id
    attr_writer :password_digest

    def initialize(attrs)
      @password_digest = BCrypt::Password.create(attrs.delete(:password))
      super(attrs)
    end

    def compare_password(password)
      @password_digest == password
    end
  end
end
