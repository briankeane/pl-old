require 'spec_helper'

module PL

  describe "GetCurrentSpin" do
    it "calls bullshit if spin is not found" do
      result = PL::GetCurrentSpin.run(99999)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:spin_not_found)
    end

    it "Gets the current spin" do
      user = PL.db.create_user({ twitter: 'bob', password: 'password'})
      song = PL.db.create_song({ title: 'Bar Lights', artist: 'Brian Keane', album: 'Coming Home', duration: 600000 })
      station = PL.db.create_station({ user_id: user.id, heavy: [song], medium: [song], light: [song] })
      spin = PL.db.schedule_spin({ station_id: station.id, played_at: Time.now, audio_block: song })
      result = PL::GetCurrentSpin.run(station.id)
      expect(result.success?).to eq(true)
      expect(result.current_spin.id).to eq(spin.id)
    end
  end
end
