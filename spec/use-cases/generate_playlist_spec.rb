require 'spec_helper'
require 'Timecop'
require 'pry-debugger'

describe 'GeneratePlaylist' do

  before (:each) do
    Timecop.freeze(Time.local(2014, 5, 9, 10))
    @user = PL.db.create_user({ twitter: "Bob", password: "password" })
    @song = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000 })
    @station = PL.db.create_station({ user_id: @user.id, heavy: [@song] })
  end

  it "calls bullshit if it can't find the station" do
    result = PL::GeneratePlaylist.run(99999)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:station_not_found)
  end

  it "generates a playlist" do
    expect(PL.db.get_full_playlist(@station.id).size).to eq(0)
    result = PL::GeneratePlaylist.run(@station.id)
    expect(result.success?).to eq(true)
    expect(PL.db.get_full_playlist(@station.id).size).to eq(4675)
  end
end
