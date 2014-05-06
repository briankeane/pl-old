require 'spec_helper'

describe 'ScheduledPlay' do
  before do
    @user = PL::Database.db.create_user({ twitter: 'bob', password: 'password', email: 'bob@bob.com' })
    @song = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
    @station = PL::Database.db.create_station({ user_id: @user.id })
  end

  it "is created with an id, song_id, station_id, current_position" do
    play = PL::ScheduledPlay.new({ id: 1, song: @song, station_id: @station.id, current_position: 3 })
    expect(play.id).to_not be_nil
    expect(play.song.id).to eq(@song.id)
    expect(play.station_id).to eq(@station.id)
    expect(play.current_position).to eq(3)
  end
end
