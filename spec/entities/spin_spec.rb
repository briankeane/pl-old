require 'spec_helper'

describe 'Spin' do
  before do
    @user = PL.db.create_user({ twitter: 'bob', password: 'password', email: 'bob@bob.com' })
    @song = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
    @station = PL.db.create_station({ user_id: @user.id })
  end

  it "is created with an id, song_id, station_id, current_position" do
    spin = PL::Spin.new({ id: 1, audio_block: @song, station_id: @station.id, current_position: 3 })
    expect(spin.id).to_not be_nil
    expect(spin.audio_block.id).to eq(@song.id)
    expect(spin.station_id).to eq(@station.id)
    expect(spin.current_position).to eq(3)
  end
end
