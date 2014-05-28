require 'spec_helper'

module PL

  describe "CreateStation" do
    it "calls bullshit if user doesn't exist" do
      result = PL::CreateStation.run({ user_id: "9999999", password: "another" })
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:user_not_found)
    end

    it "creates a station" do
      user = PL.db.create_user({ twitter: "Bob", password: "password" })
      result = PL::CreateStation.run({ user_id: user.id, heavy: [], medium: [], light: [], seconds_of_commercial_per_hour: 300 })
      expect(result.success?).to eq(true)
      expect(result.station.id).to_not be_nil
    end
  end
end
