require 'spec_helper'

module PL
  describe 'User' do
    it "is created with a twitter, id, and email" do
      user = User.new({ twitter: 'bob', email: 'bob@bob.com', password: 'password' })
      expect(user.twitter).to eq('bob')
      expect(user.email).to eq('bob@bob.com')
    end

    it "creates a secure password and tests it" do
      user = User.new({ twitter: 'bob', email: 'bob@bob.com', password: 'password' })
      expect(user.password_correct?('password')).to eq(true)
      expect(user.password_correct?('not_password')).to eq(false)
    end

  end
end
