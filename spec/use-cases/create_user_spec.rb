require 'spec_helper'

module PL

  describe "CreateUser" do
    it "calls bullshit if twitter is taken" do
      user = PL::Database.db.create_user({ twitter: "Bob", password: "password" })
      result = PL::CreateUser.run({ twitter: "Bob", password: "another" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:twitter_taken)
    end

    it "creates a user" do
      result = PL::CreateUser.run({ twitter: "Alice", password: "password2" })
      expect(result.success?).to eq(true)
      expect(result.user.id).to_not be_nil
    end
  end
end
