require 'spec_helper'
require 'Timecop'

describe "MoveSpin" do

  before(:all) do
    @user = PL::Database.db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
    @station = PL::Database.db.create_station({ user_id: @user.id })
    @song1 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song2 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song3 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song4 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song5 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song6 = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })

    @playlist = PL::Database.db.get_current_playlist(@station.id)
    expect(@playlist.size).to eq(0)

    @spin1 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song1, current_position: 5 })
    @spin2 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song2, current_position: 6 })
    @spin3 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song3, current_position: 7 })
    @spin4 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song4, current_position: 8 })
    @spin5 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song5, current_position: 9 })
    @spin6 = PL::Database.db.schedule_spin({ station_id: @station.id, audio_block: @song6, current_position: 10 })
    @spin1.played_at = Time.local(2014, 5, 9, 9, 30)
    @spin2.played_at = Time.local(2014, 5, 9, 9, 33)
  end

  it "calls bullshit if not logged in" do
    result = PL::MoveSpin.run({ pl_session_id: "BULLSHITID" })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_not_logged_in)
  end

  it "calls bullshit if old_position is invalid" do
    user = PL::Database.db.get_user(@station.user_id)
    session_id = PL::Database.db.create_session(user.id)
    result = PL::MoveSpin.run({ pl_session_id: session_id,
                                  old_position: 999,
                                  new_position: 7 })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_old_position)
  end

  it "calls bullshit if new_position is invalid" do
    user = PL::Database.db.get_user(@station.user_id)
    session_id = PL::Database.db.create_session(user.id)
    result = PL::MoveSpin.run({ pl_session_id: session_id,
                                  old_position: 7,
                                  new_position: 999 })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_new_position)
  end

  it "moves a spin" do
    user = PL::Database.db.get_user(@station.user_id)
    session_id = PL::Database.db.create_session(user.id)
    result = PL::MoveSpin.run({ pl_session_id: session_id,
                                  old_position: 7,
                                  new_position: 9 })
    expect(result.success?).to eq(true)
    expect(PL::Database.db.get_current_playlist(@station.id).map { |spin| spin.audio_block.id }).to eq([@song4.id,@song5.id,@song3.id,@song6.id])
  end
end

