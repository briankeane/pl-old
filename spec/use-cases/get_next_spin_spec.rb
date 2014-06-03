require 'spec_helper'

module PL

  describe "GetNextSpin" do
    before(:all) do
      @user = PL.db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      @station = PL.db.create_station({ user_id: @user.id })
      @song1 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song2 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song3 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song4 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song5 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song6 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })

      @playlist = PL.db.get_current_playlist(@station.id)
      expect(@playlist.size).to eq(0)

      @spin1 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song1, current_position: 5 })
      @spin2 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song2, current_position: 6 })
      @spin3 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song3, current_position: 7 })
      @spin4 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song4, current_position: 8 })
      @spin5 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song5, current_position: 9 })
      @spin6 = PL.db.schedule_spin({ station_id: @station.id, audio_block: @song6, current_position: 10 })
      PL.db.record_spin_time({ spin_id: @spin1.id, played_at: Time.local(2014, 5, 9, 9, 30)})
      PL.db.record_spin_time({ spin_id: @spin2.id, played_at: Time.local(2014, 5, 9, 9, 33)})
    end


    it "calls bullshit if spin is not found" do
      result = PL::GetNextSpin.run(99999)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:spin_not_found)
    end

    it "gets the next spin" do
      result = PL::GetNextSpin.run(@station.id)
      expect(result.success?).to eq(true)
      expect(result.next_spin.id).to eq(@spin3.id)
    end
  end
end
