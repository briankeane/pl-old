require 'spec_helper'
require 'Timecop'

describe "GetPlaylistByAirTime" do

  before(:all) do
    Timecop.freeze(Time.local(2014, 5, 9, 10))
    @user = PL.db.create_user({ twitter: "Bob", password: "password" })
    @song = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", album: "Coming Home", duration: 226000 })
    @station = PL.db.create_station({ user_id: @user.id, heavy: [@song], medium: [@song], light: [@song] })
    @station.generate_playlist
  end

  it "calls bullshit if not logged in" do
    result = PL::GetPlaylistByAirTime.run({ pl_session_id: "BULLSHITID" })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_not_logged_in)
  end

  it "calls bullshit if there's not playlist for the time selected" do
    user = PL.db.get_user(@station.user_id)
    session_id = PL.db.create_session(user.id)
    result = PL::GetPlaylistByAirTime.run({ pl_session_id: session_id,
                                            air_time: Time.new(1945, 1, 1, 1) })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:no_playlist_for_specified_time)
  end

  it "returns a good playlist for a specified time" do
    user = PL.db.get_user(@station.user_id)
    session_id = PL.db.create_session(user.id)
    Timecop.travel(2014, 5, 14, 10)
    @station.generate_playlist
    result = PL::GetPlaylistByAirTime.run({ air_time: Time.new(2014, 5, 19, 6, 55),
                                            pl_session_id: session_id })
    expect(result.success?).to eq(true)
    expect(result.playlist.size).to eq(34)
  end

  after(:all) do
    Timecop.return
  end
end

